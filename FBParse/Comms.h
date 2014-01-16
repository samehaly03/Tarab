//
//  Comms.h
//  FBParse
//
//  Created by Sameh Aly on 9/13/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOperationQueue+SharedQueue.h"

extern NSString * const N_ImageDownloaded;
extern NSString * const N_ProfilePictureLoaded;
extern NSString * const N_CommentUploaded;
extern NSString * const N_ImageUploaded;

@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
- (void) commsUploadImageProgress:(short)progress;
- (void) commsUploadImageComplete:(BOOL)success;
- (void) commsDidGetNewWallImages:(NSDate *)updated;
- (void) commsDidGetNewWallImageComments:(NSDate *)updated;
@end

@interface Comms : NSObject

+ (void) addComment:(NSString *)comment toWallImage:(WallImage *)wallImage;
+ (void) login:(id<CommsDelegate>)delegate;
+ (void) uploadImage:(UIImage *)image withAudio:(NSData *)audioData andSong:(NSString *)songName andSinger:(NSString *)singerName  forDelegate:(id<CommsDelegate>)delegate;
+ (void) getWallImagesSince:(NSDate *)lastUpdate for:(NSString *)onlyMe forDelegate:(id<CommsDelegate>)delegate;
+ (void) getWallImageCommentsSince:(NSDate *)lastUpdate forDelegate:(id<CommsDelegate>)delegate;


@end
