//
//  KANUniqueEntity.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANUniqueEntity.h"

@implementation KANUniqueEntity

+ (NSPredicate *)uniquePredicateForJSONData:(NSDictionary *)data
{
    return nil;
}

+(id <KANUniqueEntityProtocol>)initWithJSONData:(NSDictionary *)data
                                        context:(NSManagedObjectContext *)context
{
    return nil;
}

+ (id <KANUniqueEntityProtocol>)uniqueEntityForJSONData:(NSDictionary *)data
                                      withCache:(NSSet *)cache
                                        context:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    req.predicate = [self uniquePredicateForJSONData:data];
    req.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];
    
    if ([results count] == 1) {
        //NSLog(@"found existing entity");
        return [results objectAtIndex:0];
    } else {
        //NSLog(@"new entity");
        return [self initWithJSONData:data context:context];
    }
}

@end
