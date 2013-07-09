//
//  KANTrack.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"

@interface KANTrack ()
+ (KANTrack *)initWithData:(NSDictionary *)data
                       context:(NSManagedObjectContext *)context;
@end

@implementation KANTrack

NSString * const kTrackEntityName = @"Track";

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

+ (NSString *)entityName
{
    return kTrackEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    // TODO: check if key exists
    return [NSPredicate predicateWithFormat:@"uuid = %@", [data nonNullObjectForKey:@"uuid"]];
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

+ (KANTrack *)initWithData:(NSDictionary *)data
                       context:(NSManagedObjectContext *)context
{
    KANTrack *track = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                    inManagedObjectContext:context];
    
    [track updateWithData:data context:context];
    
    return track;
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:@"uuid"];
    self.name = [data nonNullObjectForKey:@"track_name"];
    self.duration = [data nonNullObjectForKey:@"duration"];
    self.group = [data nonNullObjectForKey:@"group"];
    self.lyrics = [data nonNullObjectForKey:@"lyrics"];
    self.mood = [data nonNullObjectForKey:@"mood"];
    self.num = [data nonNullObjectForKey:@"track_num"];
    self.subtitle = [data nonNullObjectForKey:@"subtitle"];
    
    if ([data nonNullObjectForKey:@"date"] != nil) {
        self.date = [[[self class] dateFormatter] dateFromString:[data nonNullObjectForKey:@"date"]];
        //NSLog(@"%@", track.date);
    }
    if ([data nonNullObjectForKey:@"original_date"] != nil) {
        self.originalDate = [[[self class] dateFormatter] dateFromString:[data nonNullObjectForKey:@"original_date"]];
    }
}



@end
