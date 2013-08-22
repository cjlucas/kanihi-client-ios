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
#import "KANAudioStore.h"

#import "UIColor+CJExtensions.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation KANAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[KANDataStore sharedDataStore] updateDataStoreDoFullUpdate:NO];
    [KANArtworkStore emptyStore];
    [KANAudioStore emptyCacheStore];
    [KANAudioStore emptyPersistentStore];
    
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

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier task = 0;
    task = [application beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Expiration handler called %f",[application backgroundTimeRemaining]);
        [application endBackgroundTask:task];
        task = UIBackgroundTaskInvalid;
    }];
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

- (void)updateNowPlayingInfo:(NSTimer *)timer
{
    NSMutableDictionary *nowPlayingInfo = [[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo mutableCopy];
    CJLog(@"%@", nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate]);

    KANAudioPlayer *ap = [KANAudioPlayer sharedPlayer];

    if (ap.progress > 0 && ap.duration > 0) {
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithDouble:ap.duration];
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithDouble:ap.progress];
    }

    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
}

#pragma mark - CJAudioPlayerDelegate methods

- (void)audioPlayer:(CJAudioPlayer *)audioPlayer didStartPlayingItem:(KANTrack *)item isFullyCached:(BOOL)fullyCached
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    if (![self.updateNowPlayingInfoTimer isValid]) {
        self.updateNowPlayingInfoTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateNowPlayingInfo:) userInfo:nil repeats:YES];
    }


    CJLog(@"%@", self);
    KANArtwork *artwork = [KANArtworkStore artworkForEntity:item];

    [KANArtworkStore loadArtwork:artwork thumbnail:NO withCompletionHandler:^(UIImage *image) {
        NSMutableDictionary *nowPlayingInfo = item.nowPlayingInfo;
        nowPlayingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:image];
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @1.0;

        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];

        [self.updateNowPlayingInfoTimer fire];
    }];
}

- (void)audioPlayerDidFinishPlayingQueue:(CJAudioPlayer *)audioPlayer
{
    [self.updateNowPlayingInfoTimer invalidate];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;

    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"audio player: %@", event);
    KANAudioPlayer *audioPlayer = [KANAudioPlayer sharedPlayer];

    switch(event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [audioPlayer togglePlayPause];
            break;

        case UIEventSubtypeRemoteControlPlay:
            [audioPlayer play];
            break;

        case UIEventSubtypeRemoteControlPause:
            [audioPlayer pause];
            break;

        case UIEventSubtypeRemoteControlNextTrack:
            [audioPlayer playNext];
            break;

        case UIEventSubtypeRemoteControlPreviousTrack:
            [audioPlayer playPrevious];
            break;
            
        default:
            break;
    }
}

@end
