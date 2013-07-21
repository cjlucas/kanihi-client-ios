//
//  KANAPI.h
//  Kanihi
//
//  Created by Chris Lucas on 7/10/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KANTrack;

@interface KANAPI : NSObject

+ (NSURLRequest *)tracksRequestWithSQLLimit:(NSUInteger)limit
                                  SQLOffset:(NSUInteger)offset
                              LastUpdatedAt:(NSDate *)lastUpdatedAt;

/*
 * if height is zero, full image will be requested
 */
+ (NSURLRequest *)artworkRequestForTrack:(KANTrack *)track
                              withHeight:(NSUInteger)height;

+ (NSDictionary *)serverInfo;
+ (NSDate *)serverTime;

/*
 * input: an array of KANTrack objects
 * returns: an array of track uuids to be deleted
 */
+ (NSArray *)deletedTracksFromCurrentTracks:(NSArray *)currentTracks;

@end
