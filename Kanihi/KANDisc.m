//
//  KANDisc.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANDisc.h"
#import "KANAlbum.h"
#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"

@implementation KANDisc

@dynamic uuid;
@dynamic name;
@dynamic normalizedName;
@dynamic num;
@dynamic trackTotal;
@dynamic album;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANDiscEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[KANDiscUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANDiscUUIDKey];
    self.name = [data nonNullObjectForKey:KANDiscNameKey];
    self.num = [data nonNullObjectForKey:KANDiscNumKey];
    self.trackTotal = [data nonNullObjectForKey:KANDiscTrackTotalKey];
    self.album = [KANAlbum uniqueEntityForData:data[KANDiscAlbumKey] withCache:nil context:context];
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    
    [self didChangeValueForKey:@"name"];
}

@end
