//
//  AppDelegate.m
//  LionTee
//
//  Created by baijin on 10/16/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "AppDelegate.h"
#import "Stripe.h"

NSString * const StripePublishableKey = @"pk_test_faqlcakROako6GtlwIbOehIN";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[Stripe setDefaultPublishableKey:StripePublishableKey];
    UIStoryboard *iPhoneStoryBoard = [UIStoryboard storyboardWithName:@"Adaptive_Main" bundle:nil];

    UIViewController *initialViewController = [iPhoneStoryBoard instantiateInitialViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.rootViewController = initialViewController;

    [self.window makeKeyAndVisible];
	
//    CGSize iOSScreenSize = [[UIScreen mainScreen] bounds].size;
//    
//    if (iOSScreenSize.height <= 568) {
//        UIStoryboard *iPhoneStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        UIViewController *initialViewController = [iPhoneStoryBoard instantiateInitialViewController];
//        
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        
//        self.window.rootViewController = initialViewController;
//        
//        [self.window makeKeyAndVisible];
//    }
//    
//    if (iOSScreenSize.height == 667) {
//        UIStoryboard *iPhone6StoryBoard = [UIStoryboard storyboardWithName:@"iPhone6" bundle:nil];
//        
//        UIViewController *initialViewController = [iPhone6StoryBoard instantiateInitialViewController];
//        
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        
//        self.window.rootViewController = initialViewController;
//        
//        [self.window makeKeyAndVisible];
//    }
//    
//    if (iOSScreenSize.height == 736) {
//        
//        UIStoryboard *iPhone6StoryBoard = [UIStoryboard storyboardWithName:@"iPhone6_Plus" bundle:nil];
//        
//        UIViewController *initialViewController = [iPhone6StoryBoard instantiateInitialViewController];
//        
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        
//        self.window.rootViewController = initialViewController;
//        
//        [self.window makeKeyAndVisible];
//    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    UIApplication * app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier background_task;
    
    [[NSRunLoop currentRunLoop] run];
    
    background_task = [app beginBackgroundTaskWithExpirationHandler:^{
        
        [app  endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
