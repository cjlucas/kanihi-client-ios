//
//  KANGenre.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANGenre.h"
#import "KANTrack.h"
#import "KANConstants.h"

#import "NSDictionary+CJExtensions.h"

@implementation KANGenre

@dynamic name;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANGenreEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"name = %@", [data nonNullObjectForKey:KANGenreNameKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:KANGenreNameKey];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    KANGenre *genre = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                           inManagedObjectContext:context];
    
    [genre updateWithData:data context:context];
    
    return genre;
}

@end
