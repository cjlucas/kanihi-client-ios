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

@dynamic uuid;
@dynamic name;
@dynamic normalizedName;
@dynamic nameSortOrder;
@dynamic sectionTitle;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANTrackArtistEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[KANTrackArtistUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANTrackArtistUUIDKey];
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

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    self.sectionTitle = [KANUtils sectionTitleForString:name];
    
    [self didChangeValueForKey:@"name"];
}

@end
