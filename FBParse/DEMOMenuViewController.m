//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "RecorderViewController.h"
#import "AllSongsViewController.h"

@interface DEMOMenuViewController ()



@end

@implementation DEMOMenuViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    songsDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       @"yones.aac",
                       @"يونس",
                       @"Mushta2a_Leek_Nancy_Ajram_karaoke.aac",
                       @"مشتاقة ليك",
                       @"Ma_Arwa3ak_Nabil_Sh3ayl_karaoke.aac",
                       @"ما اروعك",
                       @"sa2aloony_el_nas.aac",
                       @"سألوني الناس",
                       @"shoo_beny.aac",
                       @"شو بني",
                       @"Ya_Rab_Karol_Smaha_karaoke.aac",
                       @"يا رب",
                       @"Ma_Yehremneesh_Minak_Tamer_Housni_karaoke.aac",
                       @"مايحرمنيش منك",
                       @"Mesheet_Khalas_Wael_Jassar_karaoke.aac",
                       @"مشيت خلاص",
                       @"Mo3jaba_Nancy_Ajram_karaoke.aac",
                       @"معجبة",
                       @"Kermalak_Elissa_karaoke.aac",
                       @"كرمالك",
                       @"Kalam_e_Nass_George_Wassouf_karaoke.aac",
                       @"كلام الناس",
                       @"Lamset_Eid_Nancy_Ajram_karaoke.aac",
                       @"لمسة ايد",
                       @"adwa2-el-shohra.aac",
                       @"اضواء الشهرة",
                       @"agmal_e7sas.aac",
                       @"اجمل احساس",
                       @"Amr_Diab_-_Osad_Einy_Karaoke.aac",
                       @"قصاد عيني",
                       @"2albi_Mal_Rami_Ayash_karaoke.aac",
                       @"قلبي مال",
                       @"2amareen_Amr_Diab_karaoke.aac",
                       @"قمرين",
                       @"3omr_3eny.aac",
                       @"عمر عيني",
                       @"a3_39_la_el_7abayeb.aac",
                       @"اغلي الحبايب",
                       nil];
    
    self.tableView = [[UITableView alloc] init]; // Frame will be automatically set
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.tableView];
    
     [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, tableView.frame.size.width, 34)];
        view.backgroundColor = [UIColor colorWithRed:167.0/255.0f green:167.0/255.0f blue:167.0/255.0f alpha:0.6f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, view.frame.size.width, 34)];
        label.text = @"سمعني";
        label.font = [UIFont boldSystemFontOfSize:16];
        //label.textColor = [UIColor colorWithRed:242.0/255 green:108.0/255.0 blue:79.0/255.0 alpha:1.0];
        
        label.textColor = [UIColor whiteColor];
        
        //label.textColor = [UIColor colorWithRed:22.0/255.0f green:160.0/255.0f blue:133.0/255.0f alpha:0.6f];
        label.backgroundColor = [UIColor clearColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        //[label sizeToFit];
        [view addSubview:label];
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167.0/255.0f green:167.0/255.0f blue:167.0/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, view.frame.size.width, 34)];
    label.text = @"سمعنا";
    label.font = [UIFont boldSystemFontOfSize:16];
    //label.textColor = [UIColor colorWithRed:242.0/255 green:108.0/255.0 blue:79.0/255.0 alpha:1.0];
    
    label.textColor = [UIColor whiteColor];
    
    //label.textColor = [UIColor colorWithRed:22.0/255.0f green:160.0/255.0f blue:133.0/255.0f alpha:0.6f];
    label.backgroundColor = [UIColor clearColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    //[label sizeToFit];
    [view addSubview:label];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
    {
        return 64;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.section == 1)
    {
        RecorderViewController *recorderViewController = [[RecorderViewController alloc] initWithNibName:@"RecorderViewController" bundle:nil];
        
        NSArray *valuesArray = [songsDictionary allValues];
        NSString *value = [valuesArray objectAtIndex:indexPath.row];
        
        NSArray *keysArray = [songsDictionary allKeys];
        NSString *key = [keysArray objectAtIndex:indexPath.row];
        
        // Pass the selected object to the new view controller.
        recorderViewController.songPath = value;
        recorderViewController.songName = key;
        
        self.navigationController.viewControllers = @[recorderViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        [[DataStore instance] reset];
        AllSongsViewController *allViewController = [[AllSongsViewController alloc] init];
        allViewController.mine = @"NO";
        self.navigationController.viewControllers = @[allViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        [[DataStore instance] reset];
        //MyAdsViewController *myAdsViewController = [[MyAdsViewController alloc] initWithStyle:UITableViewStylePlain className:@"MyAdsViewController"];
        
        //self.navigationController.viewControllers = @[myAdsViewController];
        
        AllSongsViewController *allViewController = [[AllSongsViewController alloc] init];
        allViewController.mine = @"YES";
        self.navigationController.viewControllers = @[allViewController];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
    {
        return 2;
    }

    
    return [songsDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
//#16a085
    
    
    if (indexPath.section == 0)
    {
        NSArray *titles = @[@"كل الاغاني", @"اغنياتي"];
        [cell.textLabel setTextAlignment:NSTextAlignmentRight];
        cell.textLabel.text = titles[indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        //[cell.textLabel setTextColor:[UIColor colorWithRed:242.0/255 green:108.0/255.0 blue:79.0/255.0 alpha:1.0]];
    }
    else if (indexPath.section == 1)
    {
        // Configure the cell...
        NSMutableArray *songsValues = [[songsDictionary allKeys] copy];
        
        [cell.textLabel setTextAlignment:NSTextAlignmentRight];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        cell.textLabel.text = [songsValues objectAtIndex:indexPath.row];
    }
    

    
    return cell;
}

@end
