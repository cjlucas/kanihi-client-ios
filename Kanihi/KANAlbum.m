//
//  KANAlbum.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbum.h"
#import "KANAlbumArtist.h"

#import "NSDictionary+CJExtensions.h"


@implementation KANAlbum

NSString * const kAlbumEntityName = @"Album";

@dynamic name;
@dynamic artist;
@dynamic discs;

+ (NSString *)entityName
{
    return kAlbumEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"name = %@ && artist.name = %@",
            [data nonNullObjectForKey:@"album_name"],
            [data nonNullObjectForKey:@"album_artist"]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:@"album_name"];
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
