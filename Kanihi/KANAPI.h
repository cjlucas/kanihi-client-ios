//
//  KANAPINew.h
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "AFNetworking.h"

@class KANArtwork;
@class KANTrack;

typedef NS_ENUM(NSUInteger, KANAPIConnectability) {
    KANAPIConnectabilityNotConnectable,
    KANAPIConnectabilityConnectable,
    KANAPIConnectabilityRequiresAuthentication,
};

@interface KANAPI : AFHTTPClient

+ (KANAPI *)sharedClient;

/*
 * if height is zero, full image will be requested
 */
+ (void)performDownloadForArtwork:(KANArtwork *)artwork
                       withHeight:(NSUInteger)height
            withCompletionHandler:(void(^)(NSData *data))handler;


+ (NSUInteger)trackCountWithLastUpdatedAt:(NSDate *)lastUpdatedAt; // synchronous

+ (NSURLRequest *)tracksRequestWithSQLLimit:(NSUInteger)limit
                                  SQLOffset:(NSUInteger)offset
                              LastUpdatedAt:(NSDate *)lastUpdatedAt;

+ (NSDictionary *)serverInfo;
+ (NSDate *)serverTime;

/*
 * input: an array of KANTrack objects
 * returns: an array of track uuids to be deleted
 */
+ (NSArray *)deletedTracksRequestsWithCurrentTracks:(NSArray *)currentTracks;

/*
 * This method assumes the network is reachable, should only be used for checking user's host/port/user/pass settings
 */
+ (void)checkConnectabilityWithCompletionHandler:(void(^)(KANAPIConnectability connectability))handler;
+ (void)checkConnectabilityWithHost:(NSString *)host port:(NSUInteger)port authUser:(NSString *)authUser authPass:(NSString *)authPass completionHandler:(void(^)(KANAPIConnectability connectability))handler;

+ (NSURL *)streamURLForTrack:(KANTrack *)track;
+ (NSString *)suggestedFilenameForTrack:(KANTrack *)track;

@property (readonly) BOOL offlineMode;

@end
