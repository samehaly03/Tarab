//
//  AppDelegate.m
//  FBParse
//

#import "AppDelegate.h"
#import "FBLoginViewController.h"
#import "iRate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].usesUntilPrompt = 2;
    
	// Register our Parse Application.
    [Parse setApplicationId:@"zDv1VvcVmhGa3ejsuc39KlMsFxocF7MSfVh303Ti" clientKey:@"ycYn3OYgW0lSvqNhlUBQLFuVFhQ8LK40gXa8I2KD"];
	
    [PFUser logOut];
    
	// Initialize Parse's Facebook Utilities singleton. This uses the FacebookAppID we specified in our App bundle's plist.
	[PFFacebookUtils initializeFacebook];
	
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIView appearance] setTintColor:[UIColor whiteColor]];
    

    
    FBLoginViewController* loginVC = [[FBLoginViewController alloc] initWithNibName:@"FBLoginViewController" bundle:Nil];
    
    self.navigationController = [[DEMONavigationController alloc] initWithRootViewController:loginVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
	return YES;
}


- (BOOL) application:(UIApplication *)application
	   handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

@end
