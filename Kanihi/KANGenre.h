//
//  KANGenre.h
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANUniqueEntity.h"

@class KANTrack;

@interface KANGenre : KANUniqueEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tracks;
@end

@interface KANGenre (CoreDataGeneratedAccessors)

- (void)addTracksObject:(KANTrack *)value;
- (void)removeTracksObject:(KANTrack *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end
