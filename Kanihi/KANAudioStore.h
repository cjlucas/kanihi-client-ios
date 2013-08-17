//
//  KANAudioStore.h
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KANTrack;

@interface KANAudioStore : NSObject

+ (NSURL *)cacheURLWithFilename:(NSString *)filename;
+ (NSURL *)persistentURLWithFilename:(NSString *)filename;

+ (void)emptyCacheStore;
+ (void)emptyPersistentStore;

@end
