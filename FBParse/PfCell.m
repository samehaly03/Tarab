//
//  PfCell.m
//  FBParse
//
//  Created by Sameh Aly on 10/17/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "PfCell.h"

@implementation PfCell
@synthesize myImageView, audioUrl, lblDate, lblSong, lblSinger;
@synthesize thisView, btnPlayVideo, btnShare;

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
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)drawRect:(CGRect)rect
{   //26 188 156     #f1c40f   #9b59b6   ###d35400   #f39c12
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    
    UIColor *borderColor = [UIColor colorWithRed:155.0/255 green:89.0/255 blue:182.0/255 alpha:1.0];
    [self.myImageView.layer setBorderColor:[borderColor CGColor]];
    [self.myImageView.layer setBorderWidth:2.0];
    [self.myImageView.layer setCornerRadius:8.0];
    //[self.myImageView setClipsToBounds:YES];
    [self.myImageView.layer setMasksToBounds:YES];
    
    [self.lblSong setTextColor:[UIColor colorWithRed:243.0/255 green:156.0/255 blue:18.0/255 alpha:1.0]];
    
}


+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

+ (PfCell *)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:self options:nil] objectAtIndex:0];
}


@end
