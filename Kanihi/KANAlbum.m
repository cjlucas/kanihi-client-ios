//
//  KANAlbum.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbum.h"
#import "KANAlbumArtist.h"

#import "NSDictionary+CJExtensions.h"
#import "KANDataStore.h"


@implementation KANAlbum

@dynamic uuid;
@dynamic name;
@dynamic normalizedName;
@dynamic discTotal;
@dynamic sectionTitle;
@dynamic artist;
@dynamic discs;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANAlbumEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[KANAlbumUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANAlbumUUIDKey];
    self.name = [data nonNullObjectForKey:KANAlbumNameKey];
    self.discTotal = [data nonNullObjectForKey:KANAlbumDiscTotalKey];
    self.artist = [KANAlbumArtist uniqueEntityForData:data[KANAlbumAlbumArtistKey] withCache:[KANDataStore sharedDataStore].albumArtistCache cacheKey:KANAlbumArtistUUIDKey lookupEntity:YES context:context];
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
