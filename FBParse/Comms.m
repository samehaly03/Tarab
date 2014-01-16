//
//  Comms.m
//  FBParse
//
//  Created by Sameh Aly on 9/13/13.
//  Copyright (c) 2013 Toby Stephens. All rights reserved.
//

#import "Comms.h"

NSString * const N_ImageDownloaded = @"N_ImageDownloaded";
NSString * const N_ProfilePictureLoaded = @"N_ProfilePictureLoaded";
NSString * const N_CommentUploaded = @"N_CommentUploaded";
NSString * const N_ImageUploaded = @"N_ImageUploaded";

@implementation Comms


+ (void) loginbackup:(id<CommsDelegate>)delegate
{
	// Basic User information and your friends are part of the standard permissions
	// so there is no reason to ask for additional permissions
	[PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error)
     {
         // Was login successful ?
         if (!user)
         {
             if (!error)
             {
                 NSLog(@"The user cancelled the Facebook login.");
             }
             else
             {
                 NSLog(@"An error occurred: %@", error.localizedDescription);
             }
             
             // Callback - login failed
             if ([delegate respondsToSelector:@selector(commsDidLogin:)])
             {
                 [delegate commsDidLogin:NO];
             }
         }
         else
         {
             if (user.isNew)
             {
                 NSLog(@"User signed up and logged in through Facebook!");
             }
             else
             {
                 NSLog(@"User logged in through Facebook!");
             }
             
             // Callback - login successful
             
             // 2
             PFQuery *query = [PFQuery queryWithClassName:@"User"];
             //[query selectKeys:[NSArray arrayWithObject:@"fbid"]];
             
             [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 // 3
                 if (error) {
                     NSLog(@"Objects error: %@", error.localizedDescription);
                 } else {
                     // 4
                     // Go through the returned PFObjects
                     [objects enumerateObjectsUsingBlock:^(PFObject *userObject, NSUInteger idx, BOOL *stop) {
                         // 5
                         NSLog(@"found user");
                         // Get the Facebook User Id of the user that uploaded the image
                         NSDictionary<FBGraphUser> *user = userObject[@"fbid"];
                         
                         NSLog(@"username is %@", user.name);
                         
                     }];
                 }
                 
             }];
             
         }
     }];
}



+ (void) getWallImagesSince:(NSDate *)lastUpdate for:(NSString *)onlyMe forDelegate:(id<CommsDelegate>)delegate
{
    NSLog(@"getimagessince: %@", lastUpdate);
	// 1
	// Get the complete list of friend ids
    //PFQuery *usersQuery = [PFQuery queryWithClassName:@"User"];
    //[usersQuery select:@"fbid"];
	//NSArray *meAndMyFriends = [usersQuery findObjects];
    
	// 2
	// Create a PFQuery, Parse Query object
	PFQuery *imageQuery = [PFQuery queryWithClassName:@"WallImage"];
	[imageQuery orderByAscending:@"createdAt"];
	[imageQuery whereKey:@"updatedAt" greaterThan:lastUpdate];
    
    if ([onlyMe isEqualToString:@"YES"])
    {
        
        NSString* fbid = [[PFUser currentUser] username];
        NSLog(@"my fbid is %@", fbid);
        [imageQuery whereKey:@"user" equalTo:fbid];
    }
    
    
	[imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		// 3
		__block NSDate *newLastUpdate = lastUpdate;
        
		if (error)
        {
			NSLog(@"Objects error: %@", error.localizedDescription);
		}
        else
        {
			// 4
			// Go through the returned PFObjects
			[objects enumerateObjectsUsingBlock:^(PFObject *wallImageObject, NSUInteger idx, BOOL *stop) {
				// 5
				// Get the Facebook User Id of the user that uploaded the image
				NSDictionary<FBGraphUser> *user = [[DataStore instance].fbFriends objectForKey:wallImageObject[@"userFBId"]];
                //rgb(241, 196, 15) #f1c40f
				// 6
				// Construct a WallImage object
				WallImage *wallImage = [[WallImage alloc] init];
				wallImage.objectId = wallImageObject.objectId;
				wallImage.user = user;
                wallImage.singerName = wallImageObject[@"singerName"];
                wallImage.songName = wallImageObject[@"songName"];
				wallImage.createdDate = wallImageObject.updatedAt;
                
                PFFile *file = wallImageObject[@"audio"];
                wallImage.url = file.url;
				[[NSOperationQueue pffileOperationQueue] addOperationWithBlock:^ {
                    wallImage.image = [UIImage imageWithData:[(PFFile *)wallImageObject[@"image"] getData]];
                    
                    // Notify - Image Downloaded from Parse
                    [[NSNotificationCenter defaultCenter] postNotificationName:N_ImageDownloaded object:nil];
                  
                }];
                
				// 7
				// Update the last update timestamp with the most recent update
				if ([wallImageObject.updatedAt compare:newLastUpdate] == NSOrderedDescending) {
					newLastUpdate = wallImageObject.updatedAt;
				}
                
				// 8
				// Store the WallImage object in the DataStore collections
				[[DataStore instance].wallImages insertObject:wallImage atIndex:0];
				[[DataStore instance].wallImageMap setObject:wallImage forKey:wallImage.objectId];
			}];
		}
        
		// Callback
		if ([delegate respondsToSelector:@selector(commsDidGetNewWallImages:)]) {
			[delegate commsDidGetNewWallImages:newLastUpdate];
		}
        else
        {
            NSLog(@"delegate not respond");
        }
	}];
}

+ (void) getWallImageCommentsSince:(NSDate *)lastUpdate forDelegate:(id<CommsDelegate>)delegate
{
	// Get all the Wall Image object Ids
	NSArray *wallImageObjectIds = [DataStore instance].wallImageMap.allKeys;
	
	// Execute the PFQuery to get the Wall Image Comments for all the Wall Images
	PFQuery *commentQuery = [PFQuery queryWithClassName:@"WallImageComment"];
	[commentQuery orderByAscending:@"createdAt"];
	[commentQuery whereKey:@"updatedAt" greaterThan:lastUpdate];
	[commentQuery whereKey:@"imageObjectId" containedIn:wallImageObjectIds];
	[commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		// In the callback, we will return the latest update timestamp with this request.
		// Default to the current last update.
		__block NSDate *newLastUpdate = lastUpdate;
		
		if (error) {
			NSLog(@"Objects error: %@", error.localizedDescription);
		} else {
			[objects enumerateObjectsUsingBlock:^(PFObject *wallImageCommentObject, NSUInteger idx, BOOL *stop) {
				// Look up the User's Facebook Graph User
				NSDictionary<FBGraphUser> *user = [[DataStore instance].fbFriends objectForKey:wallImageCommentObject[@"userFBId"]];
				
				// 1
				// Look up the Wall Image
				WallImage *wallImage = [[DataStore instance].wallImageMap objectForKey:wallImageCommentObject[@"imageObjectId"]];
				
				// Add the Comment to the Wall Image
				if (wallImage) {
                    
					WallImageComment *wallImageComment = [[WallImageComment alloc] init];
                    
                    [[NSOperationQueue pffileOperationQueue] addOperationWithBlock:^ {
                        wallImageComment.commentImage = [UIImage imageWithData:[(PFFile *)wallImageCommentObject[@"commentImage"] getData]];
                        
                        // Notify - Image Downloaded from Parse
                        [[NSNotificationCenter defaultCenter] postNotificationName:N_ProfilePictureLoaded object:nil];
                        
                    }];
                    
					wallImageComment.user = user;
					wallImageComment.createdDate = wallImageCommentObject.updatedAt;
					wallImageComment.comment = wallImageCommentObject[@"comment"];
					if ([wallImageCommentObject.updatedAt compare:newLastUpdate] == NSOrderedDescending) {
						newLastUpdate = wallImageCommentObject.updatedAt;
					}
					
					//2
					[wallImage.comments addObject:wallImageComment];
				}
			}];
		}
		
		// Callback
		if ([delegate respondsToSelector:@selector(commsDidGetNewWallImageComments:)]) {
			[delegate commsDidGetNewWallImageComments:newLastUpdate];
		}
	}];
}


+ (void) login:(id<CommsDelegate>)delegate
{
    // Basic User information and your friends are part of the standard permissions
	// so there is no reason to ask for additional permissions
	[PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error)
     {
         // Was login successful ?
         if (!user)
         {
             if (!error)
             {
                 NSLog(@"The user cancelled the Facebook login.");
             }
             else
             {
                 NSLog(@"An error occurred: %@", error.localizedDescription);
             }
             
             // Callback - login failed
             if ([delegate respondsToSelector:@selector(commsDidLogin:)])
             {
                 [delegate commsDidLogin:NO];
             }
         }
         else
         {
             if (user.isNew)
             {
                 NSLog(@"User signed up and logged in through Facebook!");
             }
             else
             {
                 NSLog(@"User logged in through Facebook!");
             }
             
             // Callback - login successful
             [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error)
                 {
                     NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                     // Store the Facebook Id
                     NSString* meid = [me objectForKey:@"id"];
                     [[PFUser currentUser] setObject:meid forKey:@"fbId"];
                     [[PFUser currentUser] saveInBackground];
                  
                     [[NSUserDefaults standardUserDefaults] setObject:meid forKey:@"fbid"];
                     [[NSUserDefaults standardUserDefaults] setObject:[me objectForKey:@"email"] forKey:@"facebookEmail"];
                     
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:[me objectForKey:@"name"] forKey:@"myName"];
                     
   

                     // 1
                     FBRequest *friendsRequest = [FBRequest requestForMyFriends];
                     [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                                   NSDictionary* result,
                                                                   NSError *error) {
                         // 2
                         NSArray *friends = result[@"data"];
                         for (NSDictionary<FBGraphUser>* friend in friends) {
                             //NSLog(@"Found a friend: %@", friend.name);
                             
                             // 3
                             // Add the friend to the list of friends in the DataStore
                             //NSLog(@"friend.id is: %@", friend.id);
                             NSString *friendid = [friend objectForKey:@"id"];
                             [[DataStore instance].fbFriends setObject:friend forKey:friendid];
                         }
                         
                         // 4
                         // Callback - login successful
                         if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                             [delegate commsDidLogin:YES];
                         }
                     }];
                     
                     
                     // Launch another thread to handle the download of the user's Facebook profile picture
                     [[NSOperationQueue profilePictureOperationQueue] addOperationWithBlock:^ {
                         // Build a profile picture URL from the user's Facebook user id
                         NSString *profilePictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", me.id];
                         NSData *profilePictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profilePictureURL]];
                         UIImage *profilePicture = [UIImage imageWithData:profilePictureData];
                         
                         // Set the profile picture into the user object
                         if (profilePicture)
                         {
                             NSLog(@"there is profilepicture");
                             [me setObject:profilePicture forKey:@"fbProfilePicture"];
                             //NSData* imageData = UIImagePNGRepresentation(profilePicture);
                             
                             [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(profilePicture) forKey:@"imageKey"];
                         }
                         // Notify that the profile picture has been downloaded, using NSNotificationCenter
                         [[NSNotificationCenter defaultCenter] postNotificationName:N_ProfilePictureLoaded object:nil];
                     }];
                     
                     
                     // Add the User to the list of friends in the DataStore
                     [[DataStore instance].fbFriends setObject:me forKey:meid];
                 }
                 
             }];
         }
     }];
    
}


+ (void) uploadImage:(UIImage *)image withAudio:(NSData *)audioData andSong:(NSString *)songName andSinger:(NSString *)singerName  forDelegate:(id<CommsDelegate>)delegate
{
    // 1
    NSData *imageData = UIImagePNGRepresentation(image);
    
    // 2
    PFFile *imageFile = [PFFile fileWithName:@"img" data:imageData];
    PFFile *audioFile = [PFFile fileWithName:@"audio.caf" data:audioData];
    

    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 3
            PFObject *wallImageObject = [PFObject objectWithClassName:@"WallImage"];
            wallImageObject[@"audio"] = audioFile;
            wallImageObject[@"image"] = imageFile;
            
            if ([[PFUser currentUser] objectForKey:@"fbId"]) {
                wallImageObject[@"userFBId"] = [[PFUser currentUser] objectForKey:@"fbId"];
            }
            
            wallImageObject[@"user"] = [PFUser currentUser].username;
            wallImageObject[@"singerName"] = singerName;
            wallImageObject[@"songName"] = songName;

            
            if ([delegate respondsToSelector:@selector(commsUploadImageComplete:)]) {
                [delegate commsUploadImageComplete:YES];
            }
            
            
            [wallImageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    // 4
                    NSLog(@"succeeded");

                }
                else
                {
                    // 6
                    if ([delegate respondsToSelector:@selector(commsUploadImageComplete:)]) {
                        [delegate commsUploadImageComplete:NO];
                    }
                }
            }];
        } else {
            // 7
            if ([delegate respondsToSelector:@selector(commsUploadImageComplete:)]) {
                [delegate commsUploadImageComplete:NO];
            }
        }
    } progressBlock:^(int percentDone) {
        // 8
        if ([delegate respondsToSelector:@selector(commsUploadImageProgress:)]) {
            [delegate commsUploadImageProgress:percentDone];
        }
    }];
}

+ (void) addComment:(NSString *)comment toWallImage:(WallImage *)wallImage
{
	// Save the new Comment to the Wall Image
	PFObject *wallImageCommentObject = [PFObject objectWithClassName:@"WallImageComment"];
	wallImageCommentObject[@"comment"] = comment;
    
    if (wallImageCommentObject[@"userFBId"]) {
        wallImageCommentObject[@"userFBId"] = [[PFUser currentUser] objectForKey:@"fbId"];
    }
	
	wallImageCommentObject[@"user"] = [PFUser currentUser].username;
    
	
	// Set the object id for the associated WallImage

	wallImageCommentObject[@"imageObjectId"] = wallImage.objectId;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"imageKey"])
    {
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageKey"];
        
        PFFile *imageFile = [PFFile fileWithName:@"commentImage" data:imageData];
        
        wallImageCommentObject[@"commentImage"] = imageFile;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"user.png"];
        
        NSData* imageData = UIImagePNGRepresentation(image);
        
        PFFile *imageFile = [PFFile fileWithName:@"commentImage" data:imageData];
        
        wallImageCommentObject[@"commentImage"] = imageFile;
    }
    
	// Save the comment to Parse
	[wallImageCommentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		// Notify that the Comment has been uploaded, using NSNotificationCenter
		[[NSNotificationCenter defaultCenter] postNotificationName:N_CommentUploaded object:nil];
	}];
}


@end
