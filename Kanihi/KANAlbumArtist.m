//
//  KANAlbumArtist.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumArtist.h"

#import "NSDictionary+CJExtensions.h"

@implementation KANAlbumArtist

@dynamic uuid;
@dynamic name;
@dynamic normalizedName;
@dynamic nameSortOrder;
@dynamic sectionTitle;
@dynamic albums;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANAlbumArtistEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[KANAlbumArtistUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANAlbumArtistUUIDKey];
    self.name = [data nonNullObjectForKey:KANAlbumArtistNameKey];
    self.nameSortOrder = [data nonNullObjectForKey:KANAlbumArtistNameSortOrderKey];
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    self.sectionTitle = [KANUtils sectionTitleForString:name];
    
    [self didChangeValueForKey:@"name"];
}

- (NSString *)sectionTitle
{
    [self willAccessValueForKey:@"name"];
    NSString *name = [self primitiveValueForKey:@"name"];
    [self didAccessValueForKey:@"name"];
    
    return [[name uppercaseString] substringToIndex:1];
}

@end
