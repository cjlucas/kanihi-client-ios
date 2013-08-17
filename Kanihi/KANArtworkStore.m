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

#import "UIImage+CJExtensions.h"

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
+ (NSUInteger)thumbnailImageHeight;

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
        _fullSizeImageHeight = mainWindow.frame.size.width * [UIScreen mainScreen].scale;
    }
    
    return _fullSizeImageHeight;
}

+ (NSUInteger)thumbnailImageHeight
{
    return 200 * [UIScreen mainScreen].scale;
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
    NSURL *fullSizeDir = [cacheDir URLByAppendingPathComponent:KANArtworkStoreFullSizeDirectoryName];
    
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

+ (void)emptyStore
{
    NSArray *directories = @[[self thumbnailDirectory], [self fullSizeDirectory]];
    NSFileManager *fm = [NSFileManager defaultManager];

    for (NSURL *directory in directories) {
        NSDirectoryEnumerator *enumerator = [fm enumeratorAtURL:directory includingPropertiesForKeys:nil options:0 errorHandler:nil];

        for (NSURL *fileURL in enumerator) {
            [fm removeItemAtURL:fileURL error:nil];
        }
    }
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

    [self loadArtworkFromEntity:entity thumbnail:thumbnail withCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            view.image = image;
        });
    }];
}

+ (void)loadArtworkFromEntity:(KANEntity *)entity thumbnail:(BOOL)thumbnail withCompletionHandler:(void (^)(UIImage *))handler
{
    KANArtwork *artwork = [self artworkForEntity:entity];

    // stop crashing, proper fix later
    if (artwork == nil)
        return;

    UIImage *image;

    if (thumbnail)
        image = [[self sharedCache] objectForKey:artwork.checksum];

    // load from disk if image not in cache
    if (!image)
        image = thumbnail ? [self loadThumbnailImageForArtwork:artwork] : [self loadFullSizeImageForArtwork:artwork];

    if (image) {
        handler(image);
        if (thumbnail)
            [[self sharedCache] setObject:image forKey:artwork.checksum];

    } else {
        NSUInteger height = thumbnail ? [self thumbnailImageHeight] : [self fullSizeImageHeight];
        CJLog(@"%d", height);

        [KANAPI performDownloadForArtwork:artwork withHeight:height withCompletionHandler:^(NSData *data) {
            if (thumbnail)
                [self saveThumbnailImageData:data forArtwork:artwork];
            else
                [self saveFullSizeImage:data forArtwork:artwork];

            __block UIImage *image = [UIImage imageWithData:data];

            if (thumbnail)
                [[self sharedCache] setObject:image forKey:artwork.checksum];

            handler(image);
        }];
    }
}

+ (void)blurImage:(UIImage *)image withCompletionHandler:(void (^)(UIImage *))completionHandler
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@10.0f forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef filteredImage = [context createCGImage:result fromRect:[ciImage extent]]; // IMPORTANT: get rect from the original CIImage

    completionHandler([UIImage imageWithCGImage:filteredImage]);
}

+ (void)resizeImage:(UIImage *)image toSize:(CGSize)size withCompletionHandler:(void (^)(UIImage *))completionHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        CGSize scaledSize;
        scaledSize.width    = size.width * [UIScreen mainScreen].scale;
        scaledSize.height   = size.height * [UIScreen mainScreen].scale;

        UIImage *resizedImage = [image resizedImage:scaledSize interpolationQuality:kCGInterpolationHigh];
        completionHandler(resizedImage);
    });
}

@end
