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
+ (id <KANUniqueEntityProtocol>)uniqueEntityForJSONData:(NSDictionary *)data
                                              withCache:(NSSet *)cache
                                                context:(NSManagedObjectContext *)context;

+ (id <KANUniqueEntityProtocol>)initWithJSONData:(NSDictionary *)data
                                         context:(NSManagedObjectContext *)context;

+ (NSPredicate *)uniquePredicateForJSONData:(NSDictionary *)data;

@end


@interface KANUniqueEntity : KANEntity <KANUniqueEntityProtocol>


@end

