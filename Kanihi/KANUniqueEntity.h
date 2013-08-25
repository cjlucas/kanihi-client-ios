//
//  KANUniqueEntity.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

/*
 * KANUniqueEntity is an abstract class
 */

#import <Foundation/Foundation.h>

#import "KANEntity.h"

@protocol KANUniqueEntityProtocol <NSObject>

@required
+ (id <KANUniqueEntityProtocol>)uniqueEntityForData:(NSDictionary *)data withCache:(NSCache *)cache cacheKey:(NSString *)cacheKey lookupEntity:(BOOL)lookupEntity context:(NSManagedObjectContext *)context;


- (void)updateWithData:(NSDictionary *)data
               context:(NSManagedObjectContext *)context;

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                         context:(NSManagedObjectContext *)context;


+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data;

@end


@interface KANUniqueEntity : KANEntity <KANUniqueEntityProtocol>


@end

