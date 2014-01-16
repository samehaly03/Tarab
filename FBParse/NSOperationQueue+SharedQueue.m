//
//  NSOperationQueue+SharedQueue.m
//  FBParse
//
//  Created by Toby Stephens on 14/07/2013.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"

@implementation NSOperationQueue (SharedQueue)

+ (NSOperationQueue *) pffileOperationQueue {
	static NSOperationQueue *pffileQueue = nil;
	if (pffileQueue == nil) {
		pffileQueue = [[NSOperationQueue alloc] init];
		[pffileQueue setName:@"com.rwtutorial.pffilequeue"];
	}
	return pffileQueue;
}

+ (NSOperationQueue *) profilePictureOperationQueue {
	static NSOperationQueue *profilePictureQueue = nil;
	if (profilePictureQueue == nil) {
		profilePictureQueue = [[NSOperationQueue alloc] init];
		[profilePictureQueue setName:@"com.rwtutorial.profilepicturequeue"];
	}
	return profilePictureQueue;
}

@end
