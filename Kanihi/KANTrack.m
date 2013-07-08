//
//  KANTrack.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrack.h"

#define NIL_NOT_NULL(whatever) (whatever == [NSNull null]) ? nil : whatever

@interface KANTrack ()
+ (KANTrack *)initWithJSONData:(NSDictionary *)data
                       context:(NSManagedObjectContext *)context;
@end

@implementation KANTrack

NSString * const kEntityName = @"Track";

@dynamic date;
@dynamic duration;
@dynamic group;
@dynamic lyrics;
@dynamic mood;
@dynamic name;
@dynamic num;
@dynamic originalDate;
@dynamic subtitle;
@dynamic uuid;
@dynamic artist;
@dynamic disc;
@dynamic genre;

+ (NSPredicate *)uniquePredicateForJSONData:(NSDictionary *)data
{
    // check if key exists
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[@"uuid"]];
}

// roll this out to a category
+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return _dateFormatter;
}

+ (KANTrack *)initWithJSONData:(NSDictionary *)data
                       context:(NSManagedObjectContext *)context
{
    KANTrack *track = [NSEntityDescription insertNewObjectForEntityForName:kEntityName
                                                    inManagedObjectContext:context];
    
    track.uuid = NIL_NOT_NULL(data[@"uuid"]);
    track.name = NIL_NOT_NULL(data[@"track_name"]);
    track.duration = NIL_NOT_NULL(data[@"duration"]);
    track.group = NIL_NOT_NULL(data[@"group"]);
    track.lyrics = NIL_NOT_NULL(data[@"lyrics"]);
    track.mood = NIL_NOT_NULL(data[@"mood"]);
    track.num = NIL_NOT_NULL(data[@"track_num"]);
    track.subtitle = NIL_NOT_NULL(data[@"subtitle"]);
    if (data[@"date"] != [NSNull null]) {
        track.date = [[self dateFormatter] dateFromString:data[@"date"]];
    }
    if (data[@"original_date"] != [NSNull null]) {
        track.originalDate = [[self dateFormatter] dateFromString:data[@"original_date"]];
    }
    //track.date
    //track.originalDate
    //track.artist
    //track.disc
    //track.genre
    //
    
    return track;
}

+ (id <KANUniqueEntity>)uniqueEntityForJSONData:(NSDictionary *)data
                                        withCache:(NSSet *)cache
                                          context:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    req.predicate = [self uniquePredicateForJSONData:data];
    req.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];
    
    if ([results count] == 1) {
        NSLog(@"found existing entity");
        return [results objectAtIndex:0];
    } else {
        NSLog(@"new entity");
        return [self initWithJSONData:data context:context];
    }
}

@end
