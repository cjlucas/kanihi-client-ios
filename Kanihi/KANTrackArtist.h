//
//  KANTrackArtist.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANEntity.h"
#import "KANUNiqueEntity.h"

@class KANTrack;

@interface KANTrackArtist : KANUniqueEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameNormalized;
@property (nonatomic, retain) NSSet *tracks;
@end

@interface KANTrackArtist (CoreDataGeneratedAccessors)

- (void)addTracksObject:(KANTrack *)value;
- (void)removeTracksObject:(KANTrack *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end
