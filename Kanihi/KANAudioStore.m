//
//  KANAudioStore.m
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioStore.h"

#import "KANTrack.h"

NSString * const KANAudioStoreSubdirectoryName = @"audio";

@interface KANAudioStore ()

+ (NSURL *)cacheDirectory;
+ (NSURL *)persistentDirectory;

+ (void)emptyDirectory:(NSURL *)directory;

@end

@implementation KANAudioStore

+ (NSURL *)cacheDirectory
{
    NSURL *cacheDir = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *audioCacheDir = [cacheDir URLByAppendingPathComponent:KANAudioStoreSubdirectoryName isDirectory:YES];

    [[NSFileManager defaultManager] createDirectoryAtURL:audioCacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    return audioCacheDir;
}

+ (NSURL *)persistentDirectory
{
    NSURL *dir = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *audioDir = [dir URLByAppendingPathComponent:KANAudioStoreSubdirectoryName isDirectory:YES];

    [[NSFileManager defaultManager] createDirectoryAtURL:audioDir withIntermediateDirectories:NO attributes:nil error:nil];
    return audioDir;
}

+ (NSURL *)cacheURLWithFilename:(NSString *)filename
{
    NSURL *cacheDir = [self cacheDirectory];

    return [cacheDir URLByAppendingPathComponent:filename];
}

+ (NSURL *)persistentURLWithFilename:(NSString *)filename
{
    NSURL *dir = [self persistentDirectory];

    return [dir URLByAppendingPathComponent:filename];
}

+ (void)emptyCacheStore
{
    [self emptyDirectory:[self cacheDirectory]];
}

+ (void)emptyPersistentStore
{
    [self emptyDirectory:[self persistentDirectory]];
}

+ (void)emptyDirectory:(NSURL *)directory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtURL:directory includingPropertiesForKeys:nil options:0 errorHandler:nil];

    for (NSURL *fileURL in enumerator) {
        [fm removeItemAtURL:fileURL error:nil];
    }
}

@end
