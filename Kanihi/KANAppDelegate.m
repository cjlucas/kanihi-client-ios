//
//  KANAppDelegate.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAppDelegate.h"
#import "KANDataStore.h"
#import "CJLog.h"
#import "KANAPI.h"
#import "KANTrack.h"
#import "KANArtwork.h"

#import "KANArtworkStore.h"

@implementation KANAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] setObject:@"192.168.1.19" forKey:KANUserDefaultsHostKey];
    [[NSUserDefaults standardUserDefaults] setInteger:8080 forKey:KANUserDefaultsPortKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"chris" forKey:KANUserDefaultsAuthUserKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"test" forKey:KANUserDefaultsAuthPassKey];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KANAPIServerDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *notif) {
        CJLog(@"server became available", nil);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KANAPIServerDidBecomeUnavailableNotification object:nil queue:nil usingBlock:^(NSNotification *notif) {
        CJLog(@"server went away", nil);
    }];
    
    KANDataStore *store = [KANDataStore sharedDataStore];
    
    [store updateTracksWithFullUpdate:NO];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"Received low memory warning");
    [[KANArtworkStore sharedCache] removeAllObjects];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
