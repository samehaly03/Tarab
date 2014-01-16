//
//  ImageWallTableCommentCell.m
//  sama3na
//
//  Created by Sameh Aly on 11/20/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "ImageWallTableCommentCell.h"

@implementation ImageWallTableCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

+ (ImageWallTableCommentCell *)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:self options:nil] objectAtIndex:0];
}

- (void)drawRect:(CGRect)rect
{   //26 188 156     #f1c40f   #9b59b6   ###d35400   #f39c12
    //self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    
    //UIColor *borderColor = [UIColor colorWithRed:155.0/255 green:89.0/255 blue:182.0/255 alpha:1.0];
    //[self.profilePicture.layer setBorderColor:[borderColor CGColor]];
    //[self.profilePicture.layer setBorderWidth:0.5];
    [self.profilePicture.layer setCornerRadius:8.0];
    //[self.myImageView setClipsToBounds:YES];
    [self.profilePicture.layer setMasksToBounds:YES];
 
    
}


@end
