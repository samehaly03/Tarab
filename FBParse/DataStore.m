//
//  DataStore.m
//  FBParse
//
//  Created by Sameh Aly on 9/15/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "DataStore.h"

@implementation WallImage
- (id) init
{
    self = [super init];
    if (self) {
        // Init array of comments
        _comments = [[NSMutableArray alloc] init];
        
    }
    return self;
}
@end


@implementation WallImageComment

@end


@implementation DataStore

static DataStore *instance = nil;

+ (DataStore *) instance
{
    @synchronized (self) {
        if (instance == nil) {
            instance = [[DataStore alloc] init];
        }
    }
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        _fbFriends = [[NSMutableDictionary alloc] init];
        _wallImages = [[NSMutableArray alloc] init];
        _wallImageMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) reset
{
    [_fbFriends removeAllObjects];
    [_wallImages removeAllObjects];
    [_wallImageMap removeAllObjects];
}

@end
