//
//  KANAPINew.h
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "AFNetworking.h"

@class KANArtwork;

@interface KANAPI : AFHTTPClient

+ (KANAPI *)sharedClient;

/*
 * if height is zero, full image will be requested
 */
+ (void)performDownloadForArtwork:(KANArtwork *)artwork
                       withHeight:(NSUInteger)height
            withCompletionHandler:(void(^)(NSData *data))handler;


+ (NSURLRequest *)tracksRequestWithSQLLimit:(NSUInteger)limit
                                  SQLOffset:(NSUInteger)offset
                              LastUpdatedAt:(NSDate *)lastUpdatedAt;

+ (NSDictionary *)serverInfo;
+ (NSDate *)serverTime;

/*
 * input: an array of KANTrack objects
 * returns: an array of track uuids to be deleted
 */
+ (NSArray *)deletedTracksFromCurrentTracks:(NSArray *)currentTracks;

@end
