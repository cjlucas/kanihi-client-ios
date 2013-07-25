//
//  KANArtwork.m
//  Kanihi
//
//  Created by Chris Lucas on 7/21/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANArtwork.h"
#import "KANConstants.h"

#import "KANTrack.h"
#import "NSDictionary+CJExtensions.h"

@implementation KANArtwork

@dynamic checksum;
@dynamic artworkType;
@dynamic artworkDescription;

- (NSString *)entityName
{
    return KANArtworkEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"checksum = %@", [data nonNullObjectForKey:KANTrackUUIDKey]];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    KANTrack *track = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                    inManagedObjectContext:context];
    
    [track updateWithData:data context:context];
    
    return track;
}

@end
