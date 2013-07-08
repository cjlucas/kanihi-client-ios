//
//  KANDataStore.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANDataStore.h"

NSUInteger kFetchLimit = 10;

@interface KANDataStore ()
- (NSURLRequest *)requestWithSQLLimit:(NSUInteger)limit
                            SQLOffset:(NSUInteger)offset
                        LastUpdatedAt:(NSDate *)lastUpdatedAt;


@property (readonly) NSManagedObjectContext *backgroundManagedObjectContext;

@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation KANDataStore

// willstart update process
// didstart ...

// didstart adding and updating tracks
// did finish ...

// didstart purging old tracks
// didfinish ...

// willfinish update process
// didfinish ...
static NSString * KANDataStoreWillUpdate = @"KANDataStoreWillUpdate";
static NSString * KANDataStoreDidUpdate = @"KANDataStoreDidUpdate";

@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (KANDataStore *)sharedDataStore
{
    static KANDataStore * _sharedDataStore = nil;
    if (_sharedDataStore == nil) {
        _sharedDataStore = [[KANDataStore alloc] init];
    }
    
    return _sharedDataStore;
}

- (NSURLRequest *)requestWithSQLLimit:(NSUInteger)limit
                            SQLOffset:(NSUInteger)offset
                        LastUpdatedAt:(NSDate *)lastUpdatedAt
{
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] init];
    
    NSString *limitString = [NSString stringWithFormat:@"%d", limit];
    NSString *offsetString = [NSString stringWithFormat:@"%d", offset];
    NSString *lastUpdatedAtString = lastUpdatedAt.description;
    
    [req addValue:limitString forHTTPHeaderField:@"SQL-Limit"];
    [req addValue:offsetString forHTTPHeaderField:@"SQL-Offset"];
    [req addValue:lastUpdatedAtString forHTTPHeaderField:@"Last-Updated-At"];
    
    req.URL = [NSURL URLWithString:@"http://192.168.1.19:8080/tracks.json"];
    
    return [req copy];
}

- (void)doStuff
{
    NSUInteger offset = 0;
    NSURLRequest *req = [self requestWithSQLLimit:kFetchLimit
                                        SQLOffset:offset
                                    LastUpdatedAt:[NSDate dateWithTimeIntervalSince1970:0]];
    
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    NSLog(@"%@", error);
    
    NSArray *trackDatas = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    for (NSDictionary *trackData in trackDatas) {
        //NSLog(@"%@", trackData[@"track"]);
        KANTrack *track = [KANTrack uniqueEntityForJSONData:trackData[@"track"] withCache:nil context:self.mainManagedObjectContext];
        
        //NSLog(@"%@", track);
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"Execution Time: %f", end-start);
    [self.mainManagedObjectContext save:&error];
    NSLog(@"%@", error);
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext == nil) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext
{
    if (_backgroundManagedObjectContext == nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                               inDomains:NSUserDomainMask] lastObject]
                       URLByAppendingPathComponent:@"Kanihi.sqlite"];
    
    NSLog(@"%@", storeURL);

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error;
#warning need to check for errors here
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:storeURL
                                                    options:nil
                                                      error:&error];
    
    return _persistentStoreCoordinator;
}

@end
