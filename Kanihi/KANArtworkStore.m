//
//  KANArtworkStore.m
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANArtworkStore.h"

#import "KANAPI.h"

#import "KANTrack.h"

#import "UIImage+CJExtensions.h"

@interface KANArtworkStore ()

+ (NSURL *)thumbnailImageDirectory;
+ (NSURL *)fullSizeImageDirectory;
+ (NSURL *)blurredImageDirectory;

+ (BOOL)thumbnailImageExistsForArtwork:(KANArtwork *)artwork;
+ (BOOL)fullSizeImageExistsForArtwork:(KANArtwork *)artwork;
+ (BOOL)blurredImageExistsForArtwork:(KANArtwork *)artwork;

+ (NSURL *)thumbnailImageURLForArtwork:(KANArtwork *)artwork;
+ (NSURL *)fullSizeImageURLForArtwork:(KANArtwork *)artwork;
+ (NSURL *)blurredImageURLForArtwork:(KANArtwork *)artwork;

// returns nil if cached image not available
+ (UIImage *)loadThumbnailImageForArtwork:(KANArtwork *)artwork;
+ (UIImage *)loadFullSizeImageForArtwork:(KANArtwork *)artwork;
+ (UIImage *)loadBlurredImageForArtwork:(KANArtwork *)artwork;

+ (void)saveImageData:(NSData *)data toURL:(NSURL *)url; // helper
+ (void)saveThumbnailImageData:(NSData *)data forArtwork:(KANArtwork *)artwork;
+ (void)saveFullSizeImage:(NSData *)data forArtwork:(KANArtwork *)artwork;
+ (void)saveBlurredImage:(NSData *)data forArtwork:(KANArtwork *)artwork;

+ (NSUInteger)fullSizeImageHeight;
+ (NSUInteger)thumbnailImageHeight;

@end

@implementation KANArtworkStore

+ (NSCache *)sharedCache
{
    static NSCache *_sharedArtworkCache = nil;
    if (!_sharedArtworkCache) {
        _sharedArtworkCache = [[NSCache alloc] init];
        _sharedArtworkCache.countLimit = 20;
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
    return 80 * [UIScreen mainScreen].scale;
}

+ (void)emptyStore
{
    NSArray *directories = @[[self thumbnailImageDirectory], [self fullSizeImageDirectory], [self blurredImageDirectory]];
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
    // TODO: try to return artwork that is already cached on disk
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

#pragma mark -

+ (NSURL *)thumbnailImageDirectory
{
    NSURL *cacheDir = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *thumbnailDir = [cacheDir URLByAppendingPathComponent:KANArtworkStoreThumbnailDirectoryPath];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:thumbnailDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return thumbnailDir;
}

+ (NSURL *)fullSizeImageDirectory
{
    NSURL *cacheDir = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fullSizeDir = [cacheDir URLByAppendingPathComponent:KANArtworkStoreFullSizeDirectoryPath];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:fullSizeDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return fullSizeDir;
}

+ (NSURL *)blurredImageDirectory
{
    NSURL *cacheDir = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *blurredDir = [cacheDir URLByAppendingPathComponent:KANArtworkStoreBlurredDirectoryPath];

    [[NSFileManager defaultManager] createDirectoryAtURL:blurredDir withIntermediateDirectories:YES attributes:nil error:nil];

    return blurredDir;
}

#pragma mark -

+ (BOOL)thumbnailImageExistsForArtwork:(KANArtwork *)artwork
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self thumbnailImageURLForArtwork:artwork].path];
}

+ (BOOL)fullSizeImageExistsForArtwork:(KANArtwork *)artwork
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self fullSizeImageURLForArtwork:artwork].path];
}

+ (BOOL)blurredImageExistsForArtwork:(KANArtwork *)artwork
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self blurredImageURLForArtwork:artwork].path];
}

#pragma mark -

+ (NSURL *)thumbnailImageURLForArtwork:(KANArtwork *)artwork
{
    return [[self thumbnailImageDirectory] URLByAppendingPathComponent:artwork.checksum isDirectory:NO];
}

+ (NSURL *)fullSizeImageURLForArtwork:(KANArtwork *)artwork
{
    return [[self fullSizeImageDirectory] URLByAppendingPathComponent:artwork.checksum isDirectory:NO];
}

+ (NSURL *)blurredImageURLForArtwork:(KANArtwork *)artwork
{
    return [[self blurredImageDirectory] URLByAppendingPathComponent:artwork.checksum isDirectory:NO];
}

#pragma mark -

+ (UIImage *)loadThumbnailImageForArtwork:(KANArtwork *)artwork
{
    return [UIImage imageWithContentsOfFile:[[self thumbnailImageURLForArtwork:artwork] path]];
}

+ (UIImage *)loadFullSizeImageForArtwork:(KANArtwork *)artwork
{
    return [UIImage imageWithContentsOfFile:[[self fullSizeImageURLForArtwork:artwork] path]];

}

+ (UIImage *)loadBlurredImageForArtwork:(KANArtwork *)artwork
{
    return [UIImage imageWithContentsOfFile:[[self blurredImageURLForArtwork:artwork] path]];

}

#pragma mark -

+ (void)saveImageData:(NSData *)data toURL:(NSURL *)url
{
    [data writeToURL:url atomically:NO];
}

+ (void)saveThumbnailImageData:(NSData *)data forArtwork:(KANArtwork *)artwork
{
    [self saveImageData:data toURL:[self thumbnailImageURLForArtwork:artwork]];
}

+ (void)saveFullSizeImage:(NSData *)data forArtwork:(KANArtwork *)artwork
{
    [self saveImageData:data toURL:[self fullSizeImageURLForArtwork:artwork]];
}

+ (void)saveBlurredImage:(NSData *)data forArtwork:(KANArtwork *)artwork
{
    [self saveImageData:data toURL:[self blurredImageURLForArtwork:artwork]];
}

#pragma mark -

+ (void)attachArtwork:(KANArtwork *)artwork toImageView:(UIImageView *)view thumbnail:(BOOL)thumbnail
{
    // use the tag property of UIView to determine if the image view has been reused before the artwork has finished loading. only set the image if the identifiers match
    __block NSInteger identifier = arc4random();
    view.tag = identifier;

    dispatch_async(dispatch_get_main_queue(), ^{
        view.image = nil;
    });

    [self loadArtwork:artwork thumbnail:thumbnail withCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (view.tag == identifier) {
                view.image = image;
            }
        });
    }];
}

+ (void)loadArtwork:(KANArtwork *)artwork thumbnail:(BOOL)thumbnail withCompletionHandler:(void (^)(UIImage *))handler
{
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

+ (void)blurArtwork:(KANArtwork *)artwork withCompletionHandler:(void (^)(UIImage *))completionHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        UIImage *blurredImage = [self loadBlurredImageForArtwork:artwork];

        if (blurredImage) {
            completionHandler(blurredImage);
        } else {
            // assumes full size image already exists
            UIImage *image = [self loadFullSizeImageForArtwork:artwork];

            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:ciImage forKey:kCIInputImageKey];
            [filter setValue:@10.0f forKey:@"inputRadius"];
            CIImage *result = [filter valueForKey:kCIOutputImageKey];
            CGImageRef filteredImage = [context createCGImage:result fromRect:[ciImage extent]]; // IMPORTANT: get rect from the original CIImage

            blurredImage = [UIImage imageWithCGImage:filteredImage];

            CGImageRelease(filteredImage);

            [self saveBlurredImage:UIImagePNGRepresentation(blurredImage) forArtwork:artwork];
            
            completionHandler(blurredImage);
        }
    });
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
