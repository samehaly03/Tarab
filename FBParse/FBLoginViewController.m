//
//  FBLoginViewController.m
//  FBParse
//

#import "FBLoginViewController.h"
#import "AllSongsViewController.h"
#import "SubclassConfigViewController.h"
#import "DefaultSettingsViewController.h"

@interface FBLoginViewController () <CommsDelegate>
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnNewUser;
@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityLogin;
@end

@implementation FBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    
    self.navigationController.navigationBar.hidden = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    float x = (screenRect.size.width - 200)/2;
    float y = 64.0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 200, 200)];
    [imageView setImage:[UIImage imageNamed:@"icon-splash.png"]];
    [self.view addSubview:imageView];
    
	// Ensure the User is Logged out when loading this View Controller
	// Going forward, we would check the state of the current user and bypass the Login Screen
	// but here, the Login screen is an important part of the tutorial
	[PFUser logOut];
}

// Outlet for FBLogin button
- (IBAction) loginPressed:(id)sender
{
	// Disable the Login button to prevent multiple touches
	[_btnLogin setEnabled:NO];
	
	// Show an activity indicator
	[_activityLogin startAnimating];
	
	// Reset the DataStore so that we are starting from a fresh Login
	// as we could have come to this screen from the Logout navigation
	[[DataStore instance] reset];
	
	// Do the login
	[Comms login:self];
}


- (void) commsDidLogin:(BOOL)loggedIn
{
    NSLog(@"commsdidlogin fired");
    
	// Re-enable the Login button
	[_btnLogin setEnabled:YES];
	
	// Stop the activity indicator
	[_activityLogin stopAnimating];
	
	// Did we login successfully ?
	if (loggedIn)
    {
		// Seque to the Image Wall
		NSLog(@"logged in");
        
        AllSongsViewController *allViewController = [[AllSongsViewController alloc] init];
        allViewController.mine = @"NO";
        self.navigationController.viewControllers = @[allViewController];
        
	}
    else
    {
		// Show error alert
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
									message:@"Facebook Login failed. Please try again"
								   delegate:nil
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
	}
}

- (IBAction)newUserClicked:(id)sender
{
    NSLog(@"new user");
    
    DefaultSettingsViewController *allViewController = [[DefaultSettingsViewController alloc] init];

    self.navigationController.viewControllers = @[allViewController];
}




@end
