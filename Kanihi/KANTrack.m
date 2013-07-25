//
//  KANTrack.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"
#import "CJStringNormalization.h"

@implementation KANTrack

@dynamic date;
@dynamic duration;
@dynamic group;
@dynamic lyrics;
@dynamic mood;
@dynamic name;
@dynamic sectionTitle;
@dynamic normalizedName;
@dynamic num;
@dynamic originalDate;
@dynamic subtitle;
@dynamic uuid;
@dynamic artist;
@dynamic disc;
@dynamic genre;
@dynamic artworks;

+ (NSString *)entityName
{
    return KANTrackEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"uuid = %@", [data nonNullObjectForKey:KANTrackUUIDKey]];
}

+ (id <KANUniqueEntityProtocol>)initWithData:(NSDictionary *)data
                       context:(NSManagedObjectContext *)context
{
    KANTrack *track = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                    inManagedObjectContext:context];
    
    [track updateWithData:data context:context];
    
    return track;
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANTrackUUIDKey];
    self.name = [data nonNullObjectForKey:KANTrackNameKey];
    self.duration = [data nonNullObjectForKey:KANTrackDurationKey];
    self.group = [data nonNullObjectForKey:KANTrackGroupKey];
    self.lyrics = [data nonNullObjectForKey:KANTrackLyricsKey];
    self.mood = [data nonNullObjectForKey:KANTrackMoodKey];
    self.num = [data nonNullObjectForKey:KANTrackNumKey];
    self.subtitle = [data nonNullObjectForKey:KANTrackSubtitleKey];
    
    if ([data nonNullObjectForKey:KANTrackDateKey] != nil) {
        self.date = [KANUtils dateFromRailsDateString:[data nonNullObjectForKey:KANTrackDateKey]];
        //NSLog(@"%@", track.date);
    }
    if ([data nonNullObjectForKey:KANTrackOriginalDateKey] != nil) {
        self.originalDate = [KANUtils dateFromRailsDateString:[data nonNullObjectForKey:KANTrackOriginalDateKey]];
    }
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    self.sectionTitle = [KANUtils sectionTitleForString:name];
    
    [self didChangeValueForKey:@"name"];
}

@end
