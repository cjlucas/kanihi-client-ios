//
//  KANAlbum.h
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANUniqueEntity.h"

@class KANAlbumArtist, KANDisc;

@interface KANAlbum : KANUniqueEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * normalizedName;
@property (nonatomic, retain) NSNumber * discTotal;
@property (nonatomic, retain) KANAlbumArtist *artist;
@property (nonatomic, retain) NSSet *discs;
@end

@interface KANAlbum (CoreDataGeneratedAccessors)

- (void)addDiscsObject:(KANDisc *)value;
- (void)removeDiscsObject:(KANDisc *)value;
- (void)addDiscs:(NSSet *)values;
- (void)removeDiscs:(NSSet *)values;

@end
