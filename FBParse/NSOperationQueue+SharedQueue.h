//
//  NSOperationQueue+SharedQueue.h
//  FBParse
//
//  Created by Toby Stephens on 14/07/2013.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (SharedQueue)

+ (NSOperationQueue *) pffileOperationQueue;
+ (NSOperationQueue *) profilePictureOperationQueue;

@end
