//
//  ImageWallTableCommentCell.h
//  sama3na
//
//  Created by Sameh Aly on 11/20/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageWallTableCommentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *profilePicture;
@property (nonatomic, strong) IBOutlet UILabel *comment;

+ (ImageWallTableCommentCell *)cell;
+ (NSString *)reuseIdentifier;
- (NSString *)reuseIdentifier;

@end
