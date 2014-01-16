//
//  CutomButton.m
//  FBParse
//
//  Created by Sameh Aly on 10/9/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize buttonTitle;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.layer setCornerRadius:4.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:0.0f];
        [self.layer setBorderColor: [[UIColor grayColor] CGColor]];
        self.frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    }
    return self;
}

-(id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        [self setImage:image forState:UIControlStateNormal];
        [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.layer setCornerRadius:4.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:0.0f];
        [self.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        self.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    }
    return self;
}

-(id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self)
    {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.layer setCornerRadius:4.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:0.0f];
        [self.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        self.frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        //[self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.layer setCornerRadius:4.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:0.0f];
        [self.layer setBorderColor: [[UIColor grayColor] CGColor]];
        self.frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
