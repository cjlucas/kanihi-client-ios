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

+(id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                        context:(NSManagedObjectContext *)context
{
    return nil;
}


+ (id <KANUniqueEntityProtocol>)uniqueEntityForData:(NSDictionary *)data
                                      withCache:(NSSet *)cache
                                        context:(NSManagedObjectContext *)context
{
    assert([self entityName] != nil);
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    req.predicate = [self uniquePredicateForData:data];
    //NSLog(@"%@", req.predicate);
    req.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];
    
    id <KANUniqueEntityProtocol> entity = nil;
    
    if ([results count] == 1) {
        //NSLog(@"found existing entity");
        entity = [results objectAtIndex:0];
        [entity updateWithData:data context:context];
    } else {
        //NSLog(@"new entity");
        entity = [self initWithData:data context:context];
    }
    
    return entity;
}

@end
