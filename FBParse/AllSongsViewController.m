//
//  AllSongsViewController.m
//  sama3na
//
//  Created by Sameh Aly on 11/21/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "AllSongsViewController.h"
#import "PfCell.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DEMONavigationController.h"
#import "ImageWallTableNewCommentCell.h"
#import "ImageWallTableCommentCell.h"
#import "SVPullToRefresh.h"

@interface AllSongsViewController () <CommsDelegate> {
	NSDate *_lastImageUpdate;
    NSDate *_lastCommentUpdate;
    NSDateFormatter *_dateFormatter;
    BOOL isFiltered;
    NSMutableArray *filteredTableData;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation AllSongsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //[self.view setFrame:[[UIScreen mainScreen] bounds]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    //setup admob
    //CGRect screenRect = [self.view bounds];
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height - 20 - 44 -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    NSLog(@"origin is : %f and frame height is: %f", origin.y, self.view.frame.size.height);
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];

    [bannerView_ setDelegate:self];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = @"ca-app-pub-9017707076340173/1754048811";
    
    //old
    //bannerView_.adUnitID = @"ca-app-pub-9017707076340173/9469876011";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    //end admob
    
    //[[DataStore instance] reset];
    // Do any additional setup after loading the view from its nib.
    // Create a re-usable NSDateFormatter
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMM d, h:mm a"];
    
    // Initialize the last updated dates
    _lastImageUpdate = [NSDate distantPast];
    _lastCommentUpdate = [NSDate distantPast];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"سمعنا"];
    [self.navigationController.navigationBar.topItem setTitleView:titleLabel];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //tableview setup
    float x, y;
    float width, height;
    x = self.view.bounds.origin.x;
    y = self.view.bounds.origin.y;
    width = self.view.bounds.size.width;
    height = self.view.bounds.size.height;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height-20-44-CGSizeFromGADAdSize(kGADAdSizeBanner).height) style:UITableViewStylePlain];
    
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 100, 0);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //left button
    CustomButton *button = [[CustomButton alloc] initWithImage:[UIImage imageNamed:@"menu.png"]];
    [button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    

    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshImageWall:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = _refreshControl;
    
    // Get the Wall Images from Parse
	[self refreshImageWall:nil];

    
    // Listen for image downloads so that we can refresh the image wall
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(imageDownloaded:)
												 name:N_ImageDownloaded
											   object:nil];
	
	// Listen for profile picture downloads so that we can refresh the image wall
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(imageDownloaded:)
												 name:N_ProfilePictureLoaded
											   object:nil];
	
	// Listen for uploaded comments so that we can refresh the image wall table
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(commentUploaded:)
												 name:N_CommentUploaded
											   object:nil];
	
	// Listen for new image uploads so that we can refresh the image wall table
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(imageUploaded:)
												 name:N_ImageUploaded
											   object:nil];
    


    
    //[self resizeTable];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"--------ad fail");
    
}
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"--------ad received");
}
-(void)adViewWillPresentScreen:(GADBannerView *)adView
{
    NSLog(@"--------ad presentscreen");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) refreshImageWall:(UIRefreshControl *)refreshControl
{
    NSLog(@"lastimageupdate is %@", _lastImageUpdate);
	// Get any new Wall Images since the last update

    [Comms getWallImagesSince:_lastImageUpdate for:self.mine forDelegate:self];
    
}

- (void) commsDidGetNewWallImages:(NSDate *)updated
{
    
	// Update the update timestamp
	_lastImageUpdate = updated;
	
    NSLog(@"commsdidgetnewimage lastupdate %@", _lastImageUpdate);
    
	// Get the latest WallImageComments from Parse
	[Comms getWallImageCommentsSince:_lastCommentUpdate forDelegate:self];
	
	// Refresh the table data to show the new images
	[self.tableView reloadData];
}

- (void) commsDidGetNewWallImageComments:(NSDate *)updated {
	// Update the update timestamp
	_lastCommentUpdate = updated;
	
	// Refresh the image wall table
	[self.tableView reloadData];
	
    //[self.tableView.pullToRefreshView stopAnimating];
    
	// Update the refresh control if we have one
	if (_refreshControl) {
		NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [_dateFormatter stringFromDate:[NSDate date]]];
		[_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:lastUpdated]];
		[_refreshControl endRefreshing];
	}
}

- (void) imageDownloaded:(NSNotification *)notification
{
	[self.tableView reloadData];
}

- (void) commentUploaded:(NSNotification *)notification
{
	[self refreshImageWall:nil];
}

- (void) imageUploaded:(NSNotification *)notification
{
	[self refreshImageWall:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)sendFacebook:(id)sender {
    
    NSLog(@"sendfacebook");
    
    if (![FBDialogs canPresentOSIntegratedShareDialogWithSession:[FBSession activeSession]]) {
		NSLog(@"Facebook sharing requires a Facebook account be registered in the iPhone Settings.");
		return;
	}
    
    UIButton *button = (UIButton *)sender;
    
    WallImage *wallImage = ([DataStore instance].wallImages[button.tag]);
    NSString *audioUrl = wallImage.url;
    
    NSURL* url = [NSURL URLWithString:audioUrl];
    [FBDialogs presentShareDialogWithLink:url
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error)
                                      {
                                          NSLog(@"Error: %@", error.description);
                                      }
                                      else
                                      {
                                          NSLog(@"Success!");
                                      }
                                  }];
}

- (void)playVideo:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    
    //PfCell *cell  = (PfCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    WallImage *wallImage = ([DataStore instance].wallImages[button.tag]);
    //PFFile *audioFile = [PFFile fileWithData:wallImage.audio];
    NSString *audioUrl = wallImage.url;
    //NSLog(@"audioUrl %@", audioUrl);
    MPMoviePlayerViewController *mpvc;
    
    if (mpvc == nil)
    {
        mpvc = [[MPMoviePlayerViewController alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    
    mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [mpvc.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    //[mpvc.view setFrame:cell.myImageView.frame];
    
    mpvc.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    [mpvc.moviePlayer setContentURL:[NSURL URLWithString:audioUrl]];
    mpvc.moviePlayer.view.userInteractionEnabled = YES;
    
    
    [self presentMoviePlayerViewControllerAnimated:mpvc];
    
    
    if (!mpvc.moviePlayer.isPreparedToPlay)
    {
        [mpvc.moviePlayer prepareToPlay];
    }
    
    if (!mpvc.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [mpvc.moviePlayer play];
    }
}

- (void)moviePlaybackDidFinish:(id)sender
{
    NSLog(@"finish");
    
    if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissMoviePlayerViewControllerAnimated];
    }
    
}

-(void)resizeTable
{
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = tableFrame.size.height -
    50.0;
    
    self.tableView.frame = tableFrame;
}

- (void)deleteAd:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تأكيد" message:@"هل تريد الغاء هذه الاغنية" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
    alert.tag = button.tag;
    alert.delegate = self;
    [alert show];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Not Deleted");
    }
    else
    {
        
        WallImage *wallImage = ([DataStore instance].wallImages[alertView.tag]);
        
        PFObject* object = [PFObject objectWithoutDataWithClassName:@"WallImage" objectId:wallImage.objectId];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self refreshImageWall:nil];
            [[DataStore instance].wallImages removeObjectAtIndex:alertView.tag];
            [self.tableView reloadData];
            NSLog(@"deleted %i", alertView.tag);
        }];
    }
}
#pragma mark Table View Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CommentCellIdentifier = @"CommentCell";
	ImageWallTableCommentCell *commentCell = (ImageWallTableCommentCell *)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
    
    if (commentCell == nil)
    {
        commentCell = [ImageWallTableCommentCell cell];
    }
    
    // Get the WallImage from the indexPath.section
	WallImage *wallImage = ([DataStore instance].wallImages[indexPath.section]);
	
	static NSString *NewCommentCellIdentifier = @"NewCommentCell";
    
	if (indexPath.row >= wallImage.comments.count) {
		// If this is the last row in the section, create a NewCommentCell
		ImageWallTableNewCommentCell *newCommentCell = (ImageWallTableNewCommentCell *)[tableView dequeueReusableCellWithIdentifier:NewCommentCellIdentifier];
		
        if (newCommentCell == nil)
        {
            newCommentCell = [ImageWallTableNewCommentCell cell];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 300, 30)];
            textField.delegate = self;
            [textField setPlaceholder:@"اضف تعليق"];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setFont:[UIFont systemFontOfSize:12.0]];
            [newCommentCell.contentView addSubview:textField];
        }
        

        
		// Set the WallImage on the cell so that new comments can be associated with the correct WallImage
		newCommentCell.wallImage = wallImage;
		
		return newCommentCell;
	}
    
	// Get the associated WallImageComment from the indexPath.row
	WallImageComment *wallImageComment = wallImage.comments[indexPath.row];

    //[commentCell.profilePicture setImage:[UIImage imageNamed:@"anonymous.gif"]];
    [commentCell.profilePicture setImage:wallImageComment.commentImage];
	[commentCell.comment setText:wallImageComment.comment];
	
    return commentCell;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// One row per WallImage comment
	WallImage *wallImage = ([DataStore instance].wallImages[section]);
	return wallImage.comments.count + 1; // Add a row for the New Comment cell
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	// One section per WallImage
    //NSLog(@"number of section %i", [DataStore instance].wallImages.count);
	return [DataStore instance].wallImages.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 131;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"Cell";
    
    PfCell* cell = (PfCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [PfCell cell];
        
    }
    
	WallImage *wallImage = ([DataStore instance].wallImages[section]);
    
    //cell.audioUrl = audioFile.url;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyy"];
    NSString *date = [df stringFromDate:wallImage.createdDate];
    
    cell.lblDate.text = date;
    
    cell.lblSinger.text = wallImage.singerName;
    cell.lblSong.text = wallImage.songName;
	
	// Add the user's profile picture to the header cell
	[cell.myImageView setImage:wallImage.image];
	
    cell.btnPlayVideo.tag = section;
    [cell.btnPlayVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnShare.tag = section;
    [cell.btnShare addTarget:self action:@selector(sendFacebook:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.mine isEqualToString:@"YES"])
    {
        CustomButton *deleteButton = [[CustomButton alloc] initWithImage:[UIImage imageNamed:@"delete.png"]];
        //UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [deleteButton addTarget:self action:@selector(deleteAd:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = section;
        [deleteButton setFrame:CGRectMake(cell.myImageView.frame.origin.x +6, cell.myImageView.frame.origin.y +6, 16, 16)];
        [cell.contentView addSubview:deleteButton];
    }
    
    return cell;
}

#pragma mark TextField delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if (textField.text.length == 0)
    {
        [textField resignFirstResponder];
        return YES;
    }
    
	ImageWallTableNewCommentCell *cell = textField.superview;
    while (cell && ![cell isKindOfClass:[ImageWallTableNewCommentCell class]])
    {
        NSLog(@"yess ite is");
        cell = [cell superview];
        
    }
    
	// We have a new comment, so send it off
	[textField resignFirstResponder];
	[Comms addComment:textField.text toWallImage:cell.wallImage];
	[textField setText:@""];
	
	return YES;
}

/*
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGPoint pnt = [self.tableView convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath* path = [self.tableView indexPathForRowAtPoint:pnt];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
 */

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    /*
    //NSIndexPath* path = [self.tableView indexPathForRowAtPoint:pnt];
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    
    [self.tableView setContentOffset:contentOffset animated:YES];
    */
    
    CGPoint pnt = [textField.superview convertPoint:textField.frame.origin toView:self.tableView];
    NSIndexPath* path = [self.tableView indexPathForRowAtPoint:pnt];
    
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 300, 0);
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
    
    return YES;

}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    /*
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        ImageWallTableNewCommentCell *cell = (ImageWallTableNewCommentCell*)textField.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    */
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 100, 0);
    return YES;
}


@end
