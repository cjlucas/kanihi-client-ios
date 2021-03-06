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

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * normalizedName;
@property (nonatomic, retain) NSString * nameSortOrder;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) NSSet *albums;
@property (nonatomic, retain) NSArray *tracks;
@end

@interface KANAlbumArtist (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(KANAlbum *)value;
- (void)removeAlbumsObject:(KANAlbum *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

@end
