//
//  KANTrackArtist.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrackArtist.h"
#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"


@implementation KANTrackArtist

NSString * const kTrackArtistEntityName = @"TrackArtist";

@dynamic name;
@dynamic nameSortOrder;
@dynamic tracks;

+ (NSString *)entityName
{
    return kTrackArtistEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"name = %@", [data nonNullObjectForKey:@"track_artist"]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:@"track_artist"];
    self.nameSortOrder = [data nonNullObjectForKey:@"track_artist_sort_order"];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    KANTrackArtist *artist = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                           inManagedObjectContext:context];
    
    [artist updateWithData:data context:context];
    
    return artist;
}

@end
