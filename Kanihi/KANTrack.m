//
//  KANTrack.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrack.h"
#import "KANConstants.h"
#import "KANUtils.h"

#import "NSDictionary+CJExtensions.h"
#import "CJStringNormalization.h"

@implementation KANTrack

@dynamic date;
@dynamic duration;
@dynamic group;
@dynamic lyrics;
@dynamic mood;
@dynamic name;
@dynamic normalizedName;
@dynamic num;
@dynamic originalDate;
@dynamic subtitle;
@dynamic uuid;
@dynamic artist;
@dynamic disc;
@dynamic genre;

+ (NSString *)entityName
{
    return KANTrackEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"uuid = %@", [data nonNullObjectForKey:KANTrackUUIDKey]];
}

// move this somewhere else
+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"; // 1998-09-29T00:00:00Z
    }
    return _dateFormatter;
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
        self.date = [[[self class] dateFormatter] dateFromString:[data nonNullObjectForKey:KANTrackDateKey]];
        //NSLog(@"%@", track.date);
    }
    if ([data nonNullObjectForKey:KANTrackOriginalDateKey] != nil) {
        self.originalDate = [[[self class] dateFormatter] dateFromString:[data nonNullObjectForKey:KANTrackOriginalDateKey]];
    }
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    
    [self didChangeValueForKey:@"name"];
}

@end
