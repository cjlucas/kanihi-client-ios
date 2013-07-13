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
#import "KANConstants.h"
#import "KANUtils.h"

#import "NSDictionary+CJExtensions.h"

@implementation KANDisc

@dynamic name;
@dynamic normalizedName;
@dynamic num;
@dynamic trackTotal;
@dynamic album;
@dynamic tracks;

+ (NSString *)entityName
{
    return KANDiscEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"num = %@ && album.name = %@",
            [data nonNullObjectForKey:KANDiscNameKey],
            [data nonNullObjectForKey:KANAlbumNameKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.name = [data nonNullObjectForKey:KANDiscNameKey];
    self.num = [data nonNullObjectForKey:KANDiscNumKey];
    self.trackTotal = [data nonNullObjectForKey:KANDiscTrackTotalKey];
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

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    
    [self didChangeValueForKey:@"name"];
}

@end
