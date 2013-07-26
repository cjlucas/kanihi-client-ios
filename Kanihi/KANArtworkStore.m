//
//  KANArtworkStore.m
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANArtworkStore.h"

#import "KANArtwork.h"
#import "KANAPI.h"

#import "KANTrack.h"

@interface KANArtworkStore ()
+ (BOOL)thumbnailExistsForArtwork:(KANArtwork *)artwork;
+ (BOOL)fullSizeExistsForArtwork:(KANArtwork *)artwork;

+ (NSURL *)thumbnailURLForArtwork:(KANArtwork *)artwork;
+ (NSURL *)fullSizeURLForArtwork:(KANArtwork *)artwork;

// returns nil if cached image not available
+ (UIImage *)loadThumbnailImageForArtwork:(KANArtwork *)artwork;
+ (UIImage *)loadFullSizeImageForArtwork:(KANArtwork *)artwork;

+ (void)saveImageData:(NSData *)data toURL:(NSURL *)url; // helper
+ (void)saveThumbnailImageData:(NSData *)data forArtwork:(KANArtwork *)artwork;
+ (void)saveFullSizeImage:(NSData *)data forArtwork:(KANArtwork *)artwork;

+ (KANArtwork *)artworkForEntity:(KANEntity *)entity;

+ (NSUInteger)fullSizeImageHeight;

@end

@implementation KANArtworkStore

+ (NSCache *)sharedCache
{
    static NSCache *_sharedArtworkCache = nil;
    if (!_sharedArtworkCache) {
        _sharedArtworkCache = [[NSCache alloc] init];
        _sharedArtworkCache.name = @"SharedArtworkCache";
    }
    
    return _sharedArtworkCache;
}

+ (NSUInteger)fullSizeImageHeight
{
    static NSUInteger _fullSizeImageHeight = 0;
    
    if (_fullSizeImageHeight == 0) {
        UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
        _fullSizeImageHeight = (mainWindow.frame.size.width * mainWindow.contentScaleFactor);
    }
    
    return _fullSizeImageHeight;
}

+ (NSURL *)thumbnailDirectory
{
    NSURL *cacheDir = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *thumbnailDir = [cacheDir URLByAppendingPathComponent:KANArtworkStoreThumbnailDirectoryName];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:thumbnailDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return thumbnailDir;
}

+ (NSURL *)fullSizeDirectory
{
    NSURL *cacheDir = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fullSizeDir = [cacheDir URLByAppendingPathComponent:KANArtworkStoreThumbnailDirectoryName];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:fullSizeDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return fullSizeDir;
}

+ (BOOL)thumbnailExistsForArtwork:(KANArtwork *)artwork
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[self thumbnailURLForArtwork:artwork] absoluteString]];
}

+ (BOOL)fullSizeExistsForArtwork:(KANArtwork *)artwork
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[self fullSizeURLForArtwork:artwork] absoluteString]];
}

+ (NSURL *)thumbnailURLForArtwork:(KANArtwork *)artwork
{
    return [[self thumbnailDirectory] URLByAppendingPathComponent:artwork.checksum isDirectory:NO];
}

+ (NSURL *)fullSizeURLForArtwork:(KANArtwork *)artwork
{
    return [[self fullSizeDirectory] URLByAppendingPathComponent:artwork.checksum isDirectory:NO];
}

+ (UIImage *)loadThumbnailImageForArtwork:(KANArtwork *)artwork
{
    return [UIImage imageWithContentsOfFile:[[self thumbnailURLForArtwork:artwork] path]];
}

+ (UIImage *)loadFullSizeImageForArtwork:(KANArtwork *)artwork
{
    return [UIImage imageWithContentsOfFile:[[self fullSizeURLForArtwork:artwork] path]];

}

+ (void)saveImageData:(NSData *)data toURL:(NSURL *)url
{
    [data writeToURL:url atomically:NO];
}

+ (void)saveThumbnailImageData:(NSData *)data forArtwork:(KANArtwork *)artwork
{
    [self saveImageData:data toURL:[self thumbnailURLForArtwork:artwork]];
}

+ (void)saveFullSizeImage:(NSData *)data forArtwork:(KANArtwork *)artwork
{
    [self saveImageData:data toURL:[self fullSizeURLForArtwork:artwork]];
}

+ (KANArtwork *)artworkForEntity:(KANEntity *)entity
{
    KANArtwork *artwork = nil;
    
    if (entity == nil)
        return nil;

    if ([entity isKindOfClass:[KANTrack class]]) {
        artwork = [[(KANTrack *)entity artworks] anyObject];
    } else if ([entity respondsToSelector:@selector(tracks)]) {
        for (KANTrack *track in [entity performSelector:@selector(tracks)]) {
            for (KANArtwork *art in track.artworks) {
                if (art.artworkType == 0) {
                    artwork = art;
                    break;
                }
            }
            if (artwork)
                break;
        }
    }
    
    return artwork;
}

+ (void)attachArtworkFromEntity:(KANEntity *)entity toImageView:(UIImageView *)view thumbnail:(BOOL)thumbnail
{
    view.image = nil;
    KANArtwork *artwork = [self artworkForEntity:entity];
    
    // stop crashing, proper fix later
    if (artwork == nil)
        return;
    
    UIImage *image = [[self sharedCache] objectForKey:artwork.checksum];
    
    // load from disk if image not in cache
    if (!image)
        image = thumbnail ? [self loadThumbnailImageForArtwork:artwork] : [self loadFullSizeImageForArtwork:artwork];
    
    if (image) {
        view.image = image;
        [[self sharedCache] setObject:image forKey:artwork.checksum];
        
    } else {
        // probably not the best idea to blindly multiply the height by two. But it's fine for now as we're only supporting retina iPhones
        NSUInteger height = thumbnail ? (view.frame.size.height * 2) : [self fullSizeImageHeight];
        
        [KANAPI performDownloadForArtwork:artwork withHeight:height withCompletionHandler:^(NSData *data) {
            if (thumbnail)
                [self saveThumbnailImageData:data forArtwork:artwork];
            else
                [self saveFullSizeImage:data forArtwork:artwork];
    
            view.image = [UIImage imageWithData:data];
            [[self sharedCache] setObject:view.image forKey:artwork.checksum];
        }];
    }
}

@end
