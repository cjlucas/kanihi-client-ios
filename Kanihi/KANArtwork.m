//
//  KANArtwork.m
//  Kanihi
//
//  Created by Chris Lucas on 7/21/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANArtwork.h"

#import "KANTrack.h"
#import "NSDictionary+CJExtensions.h"

@implementation KANArtwork

@dynamic checksum;
@dynamic artworkType;
@dynamic artworkDescription;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANArtworkEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"checksum = %@", [data nonNullObjectForKey:KANTrackUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.checksum           = [data nonNullObjectForKey:KANArtworkChecksumKey];
    self.artworkType        = [data nonNullObjectForKey:KANArtworkTypeKey];
    self.artworkDescription = [data nonNullObjectForKey:KANArtworkDescriptionKey];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    KANArtwork *artwork = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                    inManagedObjectContext:context];
    
    [artwork updateWithData:data context:context];
    
    return artwork;
}

@end
