//
//  AllSongsViewController.h
//  sama3na
//
//  Created by Sameh Aly on 11/21/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AllSongsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, GADBannerViewDelegate>
{
    BOOL onscreen;
    GADBannerView *bannerView_;
}

@property (strong, nonatomic) NSString *mine;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, readwrite, nonatomic) UIColor *blurTintColor;
@property (assign, readwrite, nonatomic) CGFloat blurRadius;
@property (assign, readwrite, nonatomic) CGFloat blurSaturationDeltaFactor;
@property (assign, readwrite, nonatomic) CGFloat threshold;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readonly, nonatomic, getter = isHidden) BOOL hidden;

@property (assign, readwrite, nonatomic) CGFloat imageViewWidth;
@property (strong, readwrite, nonatomic) UIImage *image;
@property (strong, readwrite, nonatomic) UIImageView *imageView;
@property (strong, readwrite, nonatomic) UIButton *fadedView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) CGFloat minimumChildViewWidth;

@end
