//
//  KANAppDelegate.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANAudioPlayer.h"

@interface KANAppDelegate : UIResponder <UIApplicationDelegate, CJAudioPlayerDelegate>

- (void)updateNowPlayingInfo:(NSTimer *)timer;

@property (strong, nonatomic) UIWindow *window;
@property NSTimer *updateNowPlayingInfoTimer;

@end
