//
//  KANArtworkStore.h
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KANArtwork.h"

@interface KANArtworkStore : NSObject

+ (NSCache *)sharedCache;

+ (void)emptyStore;

+ (KANArtwork *)artworkForEntity:(KANEntity *)entity;

+ (void)attachArtwork:(KANArtwork *)artwork toImageView:(UIImageView *)view thumbnail:(BOOL)thumbnail;
+ (void)loadArtwork:(KANArtwork *)artwork thumbnail:(BOOL)thumbnail withCompletionHandler:(void(^)(UIImage *image))handler;
+ (void)blurArtwork:(KANArtwork *)artwork withCompletionHandler:(void(^)(UIImage *blurredImage))completionHandler;

// helper methods
+ (void)resizeImage:(UIImage *)image toSize:(CGSize)size withCompletionHandler:(void (^)(UIImage *))completionHandler;

@end
