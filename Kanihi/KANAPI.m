//
//  KANAPI.m
//  Kanihi
//
//  Created by Chris Lucas on 7/10/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAPI.h"
#import "KANConstants.h"
#import "KANTrack.h"

#import "Base64.h"
#import "NSDateFormatter+CJExtensions.h"

@interface KANAPI ()

+ (NSString *)host;

// think of a better name for this
+ (NSMutableURLRequest *)authenticatedRequest;

@end
@implementation KANAPI

+ (NSString *)host
{
    NSString *host = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsHostKey];
    NSInteger port = [[NSUserDefaults standardUserDefaults] integerForKey:KANUserDefaultsPortKey];
    
    assert(host != nil);
    assert(port > 0);
    
    return [NSString stringWithFormat:@"%@:%d", host, port];
}

+ (NSMutableURLRequest *)authenticatedRequest
{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    NSString *authUser = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsAuthUserKey];
    NSString *authPass = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsAuthPassKey];
    
    if (authUser != nil && authPass != nil) {
        NSString *authBase64 = [[NSString stringWithFormat:@"%@:%@", authUser, authPass] base64EncodedString];
        
        [req addValue:[NSString stringWithFormat:@"Basic %@", authBase64] forHTTPHeaderField:@"Authorization"];
    }
    
    return req;
}

+ (NSURLRequest *)tracksRequestWithSQLLimit:(NSUInteger)limit
                                  SQLOffset:(NSUInteger)offset
                              LastUpdatedAt:(NSDate *)lastUpdatedAt
{
    NSMutableURLRequest *req = [self authenticatedRequest];
    
    NSString *limitString = [NSString stringWithFormat:@"%d", limit];
    NSString *offsetString = [NSString stringWithFormat:@"%d", offset];
    NSString *lastUpdatedAtString = lastUpdatedAt.description; // TODO: use description with locale
    
    
    [req addValue:limitString forHTTPHeaderField:@"SQL-Limit"];
    [req addValue:offsetString forHTTPHeaderField:@"SQL-Offset"];
    [req addValue:lastUpdatedAtString forHTTPHeaderField:@"Last-Updated-At"];
    
    req.URL = [[NSURL alloc] initWithScheme:@"http" host:[self host] path:KANAPITracksPath];
    NSLog(@"%@", req);
    return [req copy];
}

+ (NSURLRequest *)artworkRequestForTrack:(KANTrack *)track
                              withHeight:(NSUInteger)height
{
    NSMutableURLRequest *req = [self authenticatedRequest];
    
    NSString *uuid = track.uuid;
    NSString *artworkPath = [NSString stringWithFormat:@"/tracks/%@/artwork", uuid];
    
    req.URL = [[NSURL alloc] initWithScheme:@"http" host:[self host] path:artworkPath];
    
    if (height > 0) {
        NSString *heightString = [NSString stringWithFormat:@"%d", height];
        [req addValue:heightString forHTTPHeaderField:@"Image-Resize-Height"];
    }
    //NSLog(@"%@", req);
    return [req copy];
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
    
    
    NSMutableURLRequest *req = [self authenticatedRequest];
    req.HTTPMethod = @"POST";
    req.HTTPBody = trackData;
    req.URL = [[NSURL alloc] initWithScheme:@"http" host:[self host] path:KANAPIDeletedTracksPath];
    
    // process returned data
    NSData *returnedData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    NSDictionary *deletedTracks = [NSJSONSerialization JSONObjectWithData:returnedData options:0 error:&error];

    return deletedTracks[@"deleted_tracks"];
}

+ (NSDictionary *)serverInfo
{
    NSError *error;
    NSMutableURLRequest *req = [self authenticatedRequest];
    req.URL = [[NSURL alloc] initWithScheme:@"http" host:[self host] path:KANAPIServerInfoPath];
    
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
