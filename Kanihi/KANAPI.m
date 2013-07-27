//
//  KANAPINew.m
//  Kanihi
//
//  Created by Chris Lucas on 7/25/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAPI.h"

#import "NSDateFormatter+CJExtensions.h"
#import "KANArtwork.h"
#import "KANTrack.h"

@interface KANAPI ()

+ (NSURL *)apiBaseURL;

- (NSString *)artworkPathWithArtwork:(KANArtwork *)artwork;

+ (NSURLRequest *)tracksRequestWithSQLLimit:(NSUInteger)limit
                                  SQLOffset:(NSUInteger)offset
                              LastUpdatedAt:(NSDate *)lastUpdatedAt;
- (void)setup;
+ (void)handleServerReachabilityStatusChange:(AFNetworkReachabilityStatus)status;
@end

@implementation KANAPI

+ (KANAPI *)sharedClient
{
    static KANAPI *_sharedClient = nil;
    
    if (!_sharedClient) {
        _sharedClient = [[KANAPI alloc] initWithBaseURL:[self apiBaseURL]];
        [_sharedClient setup];
    }
    
    return _sharedClient;
}

- (void)setup
{
    NSString *authUser = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsAuthUserKey];
    NSString *authPass = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsAuthPassKey];
    
    if (authUser && authPass)
        [self setAuthorizationHeaderWithUsername:authUser password:authPass];
    
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [KANAPI handleServerReachabilityStatusChange:status];
    }];
}


+ (void)handleServerReachabilityStatusChange:(AFNetworkReachabilityStatus)status
{
    NSLog(@"handle server reachability status: %d", status);
    NSString *notificationName = nil;
    
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        notificationName = KANAPIServerDidBecomeAvailableNotification;
    else
        notificationName = KANAPIServerDidBecomeUnavailableNotification;
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
                                                           withObject:[NSNotification notificationWithName:notificationName object:nil]
                                                        waitUntilDone:NO];
}

+ (NSURL *)apiBaseURL
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *host = [ud stringForKey:KANUserDefaultsHostKey];
    NSInteger port = [ud integerForKey:KANUserDefaultsPortKey];
    
    assert(host != nil);
    assert(port > 0);
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", host, port]];
}

- (NSString *)artworkPathWithArtwork:(KANArtwork *)artwork
{
    return [NSString stringWithFormat:@"%@/%@", KANAPIArtworkPath, artwork.checksum];
}

+ (void)performDownloadForArtwork:(KANArtwork *)artwork
                       withHeight:(NSUInteger)height
            withCompletionHandler:(void(^)(NSData *data))handler
{
    KANAPI *client = [KANAPI sharedClient];
    NSString *artworkPath = [client artworkPathWithArtwork:artwork];

    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:artworkPath parameters:nil];

    if (height > 0)
        [req addValue:[NSString stringWithFormat:@"%d", height] forHTTPHeaderField:@"Image-Resize-Height"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject ) {
        if (handler)
            handler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [op start];
}

+ (NSURLRequest *)tracksRequestWithSQLLimit:(NSUInteger)limit
                                  SQLOffset:(NSUInteger)offset
                              LastUpdatedAt:(NSDate *)lastUpdatedAt
{
    NSMutableURLRequest *req = [[self sharedClient] requestWithMethod:@"GET" path:KANAPITracksPath parameters:nil];
    
    NSString *limitString = [NSString stringWithFormat:@"%d", limit];
    NSString *offsetString = [NSString stringWithFormat:@"%d", offset];
    NSString *lastUpdatedAtString = lastUpdatedAt.description; // TODO: use description with locale
    
    
    [req addValue:limitString forHTTPHeaderField:@"SQL-Limit"];
    [req addValue:offsetString forHTTPHeaderField:@"SQL-Offset"];
    [req addValue:lastUpdatedAtString forHTTPHeaderField:@"Last-Updated-At"];
    
    NSLog(@"%@", req);
    return [req copy];
}

+ (NSArray *)trackDataWithSQLLimit:(NSUInteger)limit
                         SQLOffset:(NSUInteger)offset
                     lastUpdatedAt:(NSDate *)lastUpdatedAt
{
    NSError *error;
    NSURLRequest *req = [self tracksRequestWithSQLLimit:limit SQLOffset:offset LastUpdatedAt:lastUpdatedAt];

    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    error = nil;
    
    NSArray *trackData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return trackData;
}

+(NSArray *)deletedTracksFromCurrentTracks:(NSArray *)currentTracks
{
    NSError *error;
    
    // build array of track uuids for api
    NSMutableArray *trackUUIDs = [[NSMutableArray alloc] initWithCapacity:[currentTracks count]];
    
    for (KANTrack *track in currentTracks) {
        [trackUUIDs addObject:track.uuid];
    }
    
    NSData *trackData = [NSJSONSerialization dataWithJSONObject:@{@"current_tracks" : trackUUIDs} options:0 error:&error];
    
    
    NSMutableURLRequest *req = [[self sharedClient] requestWithMethod:@"POST" path:KANAPIDeletedTracksPath parameters:nil];
    req.HTTPBody = trackData;
    
    // process returned data
    NSData *returnedData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    NSDictionary *deletedTracks = [NSJSONSerialization JSONObjectWithData:returnedData options:0 error:&error];
    
    return deletedTracks[@"deleted_tracks"];
}

+ (NSDictionary *)serverInfo
{
    NSError *error;
    NSMutableURLRequest *req = [[self sharedClient] requestWithMethod:@"GET" path:KANAPIServerInfoPath parameters:nil];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    NSDictionary *serverInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    return serverInfo[@"server_info"];
}

+ (NSDate *)serverTime
{
    NSDate *serverTime = nil;
    NSDictionary *serverInfo = [self serverInfo];
    
    if (serverInfo != nil) {
        serverTime = [[NSDateFormatter rfc3339] dateFromString:serverInfo[@"server_time"]];
    }
    
    return serverTime;
}

@end
