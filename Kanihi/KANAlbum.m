//
//  KANAlbum.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbum.h"
#import "KANAlbumArtist.h"
#import "KANConstants.h"

#import "NSDictionary+CJExtensions.h"


@implementation KANAlbum

@dynamic name;
@dynamic artist;
@dynamic discs;

+ (NSString *)entityName
{
    return KANAlbumEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"name = %@ && artist.name = %@",
            [data nonNullObjectForKey:KANAlbumNameKey],
            [data nonNullObjectForKey:KANAlbumArtistNameKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:KANAlbumNameKey];
    self.artist = [KANAlbumArtist uniqueEntityForData:data withCache:nil context:context];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    KANAlbum *album = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                           inManagedObjectContext:context];
    
    [album updateWithData:data context:context];
    
    return album;
}

@end