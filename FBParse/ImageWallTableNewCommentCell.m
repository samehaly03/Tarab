//
//  ImageWallTableNewCommentCell.m
//  sama3na
//
//  Created by Sameh Aly on 11/20/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "ImageWallTableNewCommentCell.h"

@implementation ImageWallTableNewCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.txtComment.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if (textField.text.length == 0)
    {
        [textField resignFirstResponder];
        return YES;
    }
    
	
	// We have a new comment, so send it off
	[textField resignFirstResponder];
	[Comms addComment:textField.text toWallImage:_wallImage];
	[textField setText:@""];
	
	return YES;
}
*/

- (void)drawRect:(CGRect)rect
{
    [_txtComment.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_txtComment.layer setBorderWidth:0.2];
    [_txtComment.layer setCornerRadius:3.0];
    [_txtComment setClipsToBounds:YES];

    //[self.leftImageView.layer setCornerRadius:4.0];
    //[self.leftImageView setClipsToBounds:YES];
    
    //[self.rightImageView.layer setCornerRadius:4.0];
    //[self.rightImageView setClipsToBounds:YES];
    
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

+ (ImageWallTableNewCommentCell *)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:self options:nil] objectAtIndex:0];
}

@end
