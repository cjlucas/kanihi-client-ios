//
//  KANTrackArtist.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrackArtist.h"
#import "KANTrack.h"
#import "KANConstants.h"

#import "NSDictionary+CJExtensions.h"


@implementation KANTrackArtist

@dynamic name;
@dynamic nameSortOrder;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANTrackArtistEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"name = %@", [data nonNullObjectForKey:KANTrackArtistNameKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:KANTrackArtistNameKey];
    self.nameSortOrder = [data nonNullObjectForKey:KANTrackArtistNameSortOrderKey];
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