//
//  ImageWallTableNewCommentCell.h
//  sama3na
//
//  Created by Sameh Aly on 11/20/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageWallTableNewCommentCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *txtComment;
@property (nonatomic, strong) WallImage *wallImage;

+ (ImageWallTableNewCommentCell *)cell;
+ (NSString *)reuseIdentifier;
- (NSString *)reuseIdentifier;

@end
