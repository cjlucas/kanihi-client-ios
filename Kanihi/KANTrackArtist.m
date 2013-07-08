//
//  KANTrackArtist.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrackArtist.h"
#import "KANTrack.h"


@implementation KANTrackArtist

NSString * const kTrackArtistEntityName = @"TrackArtist";

@dynamic name;
@dynamic nameNormalized;
@dynamic tracks;



- (void)setName:(NSString *)newName
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:[newName copy] forKey:@"name"];
    [self didChangeValueForKey:@"name"];
    
    self.nameNormalized = [[self class] normalizedStringForString:newName];
}

+ (KANTrackArtist *)initWithJSONData:(NSDictionary *)data
                             context:(NSManagedObjectContext *)context
{
    KANTrackArtist *artist = [NSEntityDescription insertNewObjectForEntityForName:kTrackArtistEntityName
                                                           inManagedObjectContext:context];
    artist.name = data[@"track_artist"];
    
    return artist;
}

+ (NSPredicate *)uniquePredicateForJSONData:(NSDictionary *)data
{
    NSString *normalizedString = [self normalizedStringForString:data[@"track_artist"]];
    return [NSPredicate predicateWithFormat:@"nameNormalized = %@", normalizedString];
}

+ (id <KANUniqueEntity>)uniqueEntityForJSONData:(NSDictionary *)data
                                      withCache:(NSSet *)cache
                                        context:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kTrackArtistEntityName];
    req.predicate = [self uniquePredicateForJSONData:data];
    req.fetchLimit = 1;

    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];
    
    if ([results count] == 1) {
        NSLog(@"exists already");
        return [results objectAtIndex:0];
    } else {
        NSLog(@"new track artist");
        return [self initWithJSONData:data context:context];
    }
}


@end
