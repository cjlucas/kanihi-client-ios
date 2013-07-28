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

- (void)setup;
+ (void)handleServerReachabilityStatusChange:(AFNetworkReachabilityStatus)status;
@end

@implementation KANAPI

@synthesize offlineMode = _offlineMode;

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
    // TODO: move this elsewhere
    NSString *authUser = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsAuthUserKey];
    NSString *authPass = [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsAuthPassKey];
    
    if (authUser && authPass)
        [self setAuthorizationHeaderWithUsername:authUser password:authPass];

    // limit concurrent operations
    [self.operationQueue setMaxConcurrentOperationCount:KANAPIMaxConcurrentConnections];

    // handle reachability status changes
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [KANAPI handleServerReachabilityStatusChange:status];
    }];

    // register AFHTTPOperation subclasses
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

    // add observers for server availability notifications
    [[NSNotificationCenter defaultCenter] addObserverForName:KANAPIServerDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        _offlineMode = NO;
        CJLog(@"disabling offline mode", nil);
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:KANAPIServerDidBecomeUnavailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        _offlineMode = YES;
        CJLog(@"enabling offline mode", nil);
    }];

}


+ (void)handleServerReachabilityStatusChange:(AFNetworkReachabilityStatus)status
{
//    NSLog(@"handle server reachability status: %d", status);
//    NSString *notificationName = nil;
//    
//    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
//        notificationName = KANAPIServerDidBecomeAvailableNotification;
//    else
//        notificationName = KANAPIServerDidBecomeUnavailableNotification;
//    
//    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
//                                                           withObject:[NSNotification notificationWithName:notificationName object:nil]
//                                                        waitUntilDone:NO];
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

    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id respnseObject) {
        if (handler)
            handler(respnseObject);
    };

    AFHTTPRequestOperation *op = [[KANAPI sharedClient] HTTPRequestOperationWithRequest:req success:success failure:nil];

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
    
    return [req copy];
}

+ (NSURLRequest *)deletedTracksRequestFromCurrentTracks:(NSArray *)currentTracks
{
    NSError *error;
    
    // build array of track uuids for api
    NSMutableArray *trackUUIDs = [[NSMutableArray alloc] initWithCapacity:[currentTracks count]];
    
    for (KANTrack *track in currentTracks) {
        [trackUUIDs addObject:track.uuid];
    }
    
    NSData *trackData = [NSJSONSerialization dataWithJSONObject:@{KANAPIDeletedTracksRequestJSONKey: trackUUIDs} options:0 error:&error];
    NSMutableURLRequest *req = nil;
    
    if (error) {
        CJLog(@"Error while serializing current tracks", nil);
    } else {
        req = [[self sharedClient] requestWithMethod:@"POST" path:KANAPIDeletedTracksPath parameters:nil];
        req.HTTPBody = trackData;
    }

    return [req copy];
}

+ (NSDictionary *)serverInfo
{
    NSError *error;
    NSMutableURLRequest *req = [[self sharedClient] requestWithMethod:@"GET" path:KANAPIServerInfoPath parameters:nil];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    if (error) {
        CJLog(@"%@", error);
        return nil;
    }
    
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

+ (NSUInteger)trackCountWithLastUpdatedAt:(NSDate *)lastUpdatedAt
{
    NSError *error;
    NSUInteger trackCount = 0;
    NSMutableURLRequest *req = [[self sharedClient] requestWithMethod:@"GET" path:KANAPITrackCountPath parameters:nil];
    
    if (lastUpdatedAt)
        [req addValue:lastUpdatedAt.description forHTTPHeaderField:@"Last-Updated-At"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    
    if (error) {
        CJLog(@"%@", error);
    } else {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        trackCount = [(NSNumber *)json[KANAPITrackCountKey] integerValue];
    }
    
    return trackCount;
}

+ (void)checkConnectabilityWithCompletionHandler:(void (^)(KANAPIConnectability))handler
{
    assert(handler != nil);
    KANAPI *client = [self sharedClient];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:nil parameters:nil];
    req.timeoutInterval = 5;
    
    AFHTTPRequestOperation *op = [client HTTPRequestOperationWithRequest:req success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"testConnectability successful");
        handler(KANAPIConnectabilityConnectable);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"testConnectability failed: %@", error);
        
        if (operation.response.statusCode == 401)
            handler(KANAPIConnectabilityRequiresAuthentication);
        else
            handler(KANAPIConnectabilityNotConnectable);
    }];
    
    [op start];
}

#pragma mark - AFHTTPClient overrides

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    void (^interveningSuccessBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // send notification if we're back online
        if ([[KANAPI sharedClient] offlineMode]) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [[NSNotificationCenter defaultCenter] postNotificationName:KANAPIServerDidBecomeAvailableNotification object:nil];
            });
        }

        // call original block
        if (success)
            success(operation, responseObject);
    };

    void (^interveningFailureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        CJLog(@"%@", error);
        BOOL shouldSendOfflineNotification = NO;

        if (error.domain == NSURLErrorDomain) {
            switch (error.code) {
                case NSURLErrorCannotConnectToHost:
                    shouldSendOfflineNotification = YES;
                    break;
                case NSURLErrorCannotLoadFromNetwork:
                    shouldSendOfflineNotification = YES;
                    break;
                case NSURLErrorUserAuthenticationRequired:
                    shouldSendOfflineNotification = YES;
                    break;
            }
        }

        if (shouldSendOfflineNotification) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [[NSNotificationCenter defaultCenter] postNotificationName:KANAPIServerDidBecomeUnavailableNotification object:nil];
            });
        }

        // call original block
        if (failure)
            failure(operation, error);
    };

    return [super HTTPRequestOperationWithRequest:urlRequest success:interveningSuccessBlock failure:interveningFailureBlock];
}

@end
