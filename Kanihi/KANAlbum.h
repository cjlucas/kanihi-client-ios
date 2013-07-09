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

@class KANAlbumArtist;

@interface KANAlbum : KANUniqueEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) KANAlbumArtist *artist;
@property (nonatomic, retain) NSSet *discs;
@end

@interface KANAlbum (CoreDataGeneratedAccessors)

- (void)addDiscsObject:(NSManagedObject *)value;
- (void)removeDiscsObject:(NSManagedObject *)value;
- (void)addDiscs:(NSSet *)values;
- (void)removeDiscs:(NSSet *)values;

@end
