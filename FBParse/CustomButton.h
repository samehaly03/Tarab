//
//  CutomButton.h
//  FBParse
//
//  Created by Sameh Aly on 10/9/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property(nonatomic, strong) NSString* buttonTitle;

- (id)initWithTitle:(NSString *)title;
-(id)initWithImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;

@end
