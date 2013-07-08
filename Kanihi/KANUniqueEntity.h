//
//  KANUniqueEntity.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KANUniqueEntity <NSObject>

@required
+ (id <KANUniqueEntity>)uniqueEntityForJSONData:(NSDictionary *)data
                                        withCache:(NSSet *)cache
                                          context:(NSManagedObjectContext *)context;
+ (NSPredicate *)uniquePredicateForJSONData:(NSDictionary *)data;

@end