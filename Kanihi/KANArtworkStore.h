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
+ (void)attachArtworkFromEntity:(KANEntity *)entity toImageView:(UIImageView *)view thumbnail:(BOOL)thumbnail;
@end
