//
//  KANGenre.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANGenre.h"
#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"

@implementation KANGenre

@dynamic uuid;
@dynamic name;
@dynamic normalizedName;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANGenreEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[KANGenreUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANGenreUUIDKey];
    self.name = [data nonNullObjectForKey:KANGenreNameKey];
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    
    [self didChangeValueForKey:@"name"];
}

@end
