//
//  DataStore.h
//  FBParse
//
//  Created by Sameh Aly on 9/15/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallImage : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) id objectId;
@property (nonatomic, strong) NSDictionary<FBGraphUser> *user;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSData *audio;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *singerName;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSMutableArray *comments;

@end

@interface WallImageComment : NSObject
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *commentTitle;
@property (nonatomic, strong) NSDictionary<FBGraphUser> *user;
@property (nonatomic, strong) UIImage *commentImage;
@property (nonatomic, strong) NSDate *createdDate;
@end


@interface DataStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *fbFriends;
@property (nonatomic, strong) NSMutableArray *wallImages;
@property (nonatomic, strong) NSMutableDictionary *wallImageMap;

+ (DataStore *) instance;
- (void) reset;

@end