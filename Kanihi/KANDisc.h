//
//  KANDisc.h
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANUniqueEntity.h"

@class KANAlbum, KANTrack;

@interface KANDisc : KANUniqueEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSNumber *num;
@property (nonatomic) NSNumber *trackTotal;
@property (nonatomic, retain) KANAlbum *album;
@property (nonatomic, retain) NSSet *tracks;
@end

@interface KANDisc (CoreDataGeneratedAccessors)

- (void)addTracksObject:(KANTrack *)value;
- (void)removeTracksObject:(KANTrack *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end
