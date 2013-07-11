//
//  KANAlbumArtist.h
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANUniqueEntity.h"

@class KANAlbum;

@interface KANAlbumArtist : KANUniqueEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameSortOrder;
@property (nonatomic, retain) NSSet *albums;
@end

@interface KANAlbumArtist (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(KANAlbum *)value;
- (void)removeAlbumsObject:(KANAlbum *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

@end
