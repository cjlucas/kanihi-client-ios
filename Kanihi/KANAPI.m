//
//  KANAPI.m
//  Kanihi
//
//  Created by Chris Lucas on 7/10/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAPI.h"
#import "KANConstants.h"
#import "Base64.h"

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
        
        [req addValue:@"Authorization" forHTTPHeaderField:[NSString stringWithFormat:@"Basic %@", authBase64]];
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
@end
