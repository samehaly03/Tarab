//
//  PfCell.h
//  FBParse
//
//  Created by Sameh Aly on 10/17/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PfCell : UITableViewCell

@property (nonatomic, strong)IBOutlet NSString* audioUrl;
@property (nonatomic, strong)IBOutlet UIView* thisView;
@property (nonatomic, strong)IBOutlet PFImageView* myImageView;
@property (nonatomic, strong)IBOutlet UIImageView* rightImageView;
@property (nonatomic, strong)IBOutlet UIImageView* leftImageView;
@property (nonatomic, strong)IBOutlet UILabel* lblSinger;
@property (nonatomic, strong)IBOutlet UILabel* lblDate;
@property (nonatomic, strong)IBOutlet UILabel* lblSong;
@property (nonatomic, strong)IBOutlet UIButton* btnPlayVideo;
@property (nonatomic, strong)IBOutlet UIButton* btnShare;

+ (PfCell *)cell;
+ (NSString *)reuseIdentifier;
- (NSString *)reuseIdentifier;


@end
