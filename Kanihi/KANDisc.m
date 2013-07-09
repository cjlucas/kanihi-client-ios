//
//  KANDisc.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANDisc.h"
#import "KANAlbum.h"
#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"

@implementation KANDisc

NSString * const kKANDiscEntityName = @"Disc";

@dynamic name;
@dynamic num;
@dynamic trackTotal;
@dynamic album;
@dynamic tracks;

+ (NSString *)entityName
{
    return kKANDiscEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"num = %@ && album.name = %@",
            [data nonNullObjectForKey:@"disc_num"],
            [data nonNullObjectForKey:@"album_name"]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:@"disc_subtitle"];
    self.num = [data nonNullObjectForKey:@"disc_num"];
    self.trackTotal = [data nonNullObjectForKey:@"track_total"];
    self.album = [KANAlbum uniqueEntityForData:data withCache:nil context:context];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                                     context:(NSManagedObjectContext *)context
{
    KANDisc *disc = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                  inManagedObjectContext:context];
    
    [disc updateWithData:data context:context];
    
    return disc;
}

@end
