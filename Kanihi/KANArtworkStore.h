//
//  KANArtworkStore.h
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KANEntity.h"

@interface KANArtworkStore : NSObject

+ (NSCache *)sharedCache;

+ (void)emptyStore;

+ (void)attachArtworkFromEntity:(KANEntity *)entity toImageView:(UIImageView *)view thumbnail:(BOOL)thumbnail;
+ (void)loadArtworkFromEntity:(KANEntity *)entity thumbnail:(BOOL)thumbnail withCompletionHandler:(void(^)(UIImage *image))handler;

+ (void)blurImage:(UIImage *)image withCompletionHandler:(void(^)(UIImage *blurredImage))completionHandler;
+ (void)resizeImage:(UIImage *)image toSize:(CGSize)size withCompletionHandler:(void(^)(UIImage *resizedImage))completionHandler;

@end
