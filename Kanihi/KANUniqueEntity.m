//
//  KANUniqueEntity.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANUniqueEntity.h"

@implementation KANUniqueEntity

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return nil;
}

- (void)updateWithData:(NSDictionary *)data
               context:(NSManagedObjectContext *)context
{
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    if (!data) {
        return nil;
    }

    id <KANUniqueEntityProtocol> record = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [record updateWithData:data context:context];

    return record;
}

+ (id <KANUniqueEntityProtocol>)uniqueEntityForData:(NSDictionary *)data withCache:(NSCache *)cache cacheKey:(NSString *)cacheKey lookupEntity:(BOOL)lookupEntity context:(NSManagedObjectContext *)context
{
    assert([self entityName] != nil);
    assert(context != nil);

    id <KANUniqueEntityProtocol> entity = nil;

    if (lookupEntity) {
        if (cache && cacheKey) {
            entity = [cache objectForKey:cacheKey];
        }

        if (!entity) {
            NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
            req.predicate = [self uniquePredicateForData:data];
            req.fetchLimit = 1;

            NSError *error;
            NSArray *results = [context executeFetchRequest:req error:&error];

            if (results.count == 1) {
                entity = results[0];
                [entity updateWithData:data context:context];
            }
        }
    }

    if (!entity) {
        entity = [self initWithData:data context:context];
    }

    if (cache && cacheKey) {
        [cache setObject:entity forKey:cacheKey];
    }

    return entity;
}

@end
