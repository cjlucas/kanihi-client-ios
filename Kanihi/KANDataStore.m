//
//  KANDataStore.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CJLog.h"

#import "KANDataStore.h"

#import "KANAPI.h"

#import "KANTrack.h"
#import "KANTrackArtist.h"
#import "KANDisc.h"
#import "KANGenre.h"
#import "KANArtwork.h"

@interface KANDataStore ()

- (void)performUpdateWithFullUpdate:(NSNumber *)fullUpdate;
- (void)handleTrackDatas:(NSArray *)trackDatas;
- (void)deleteTracksWithUUIDArray:(NSArray *)uuids;
- (NSArray *)allTracks; // returns a batched core data proxy array

- (void)postNotification:(NSString *)notification;
- (void)postNotificationHelper:(NSString *)notification;

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread;

@property (readonly) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property NSThread *backgroundThread;

@end

@implementation KANDataStore

@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)postNotification:(NSString *)notification
{
    [self performSelectorOnMainThread:@selector(postNotificationHelper:) withObject:notification waitUntilDone:YES];
}

- (void)postNotificationHelper:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

+ (KANDataStore *)sharedDataStore
{
    static KANDataStore * _sharedDataStore = nil;
    if (_sharedDataStore == nil) {
        _sharedDataStore = [[KANDataStore alloc] init];
    }
    
    return _sharedDataStore;
}

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread
{
    return [thread isMainThread] ? self.mainManagedObjectContext : self.backgroundManagedObjectContext;
}

- (void)handleTrackDatas:(NSArray *)trackDatas
{
    for (NSDictionary *trackData in trackDatas) {
        KANTrack *track = [KANTrack uniqueEntityForData:trackData[@"track"]
                                              withCache:nil
                                                context:self.backgroundManagedObjectContext];
        
        track.artist = [KANTrackArtist uniqueEntityForData:trackData[@"track"]
                                                 withCache:nil
                                                   context:self.backgroundManagedObjectContext];
        
        track.disc = [KANDisc uniqueEntityForData:trackData[@"track"]
                                        withCache:nil
                                          context:self.backgroundManagedObjectContext];
        
        track.genre = [KANGenre uniqueEntityForData:trackData[@"track"]
                                          withCache:nil
                                            context:self.backgroundManagedObjectContext];
        
        NSMutableSet *artworks = [track mutableSetValueForKey:@"artworks"]; // core data proxy set
        
        // ensure artwork isn't already in track.artworks by doing a checksum lookup before adding
        NSMutableSet *checksums = [[NSMutableSet alloc] initWithCapacity:artworks.count];
        for (KANArtwork *artwork in artworks)
            [checksums addObject:[artwork.checksum lowercaseString]];
        
        for (NSDictionary *artworkData in trackData[@"track"][KANTrackArtworkKey]) {
            KANArtwork *artwork = [KANArtwork uniqueEntityForData:artworkData[KANArtworkKey]
                                                        withCache:nil
                                                          context:self.backgroundManagedObjectContext];
            
            if (![checksums containsObject:[artwork.checksum lowercaseString]])
                [artworks addObject:artwork];
        }
    }
}

- (void)updateTracksWithFullUpdate:(BOOL)fullUpdate
{
    if (![self.backgroundThread isExecuting]) {
        self.backgroundThread = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(performUpdateWithFullUpdate:)
                                                          object:[NSNumber numberWithBool:fullUpdate]]; // an object is required
        self.backgroundThread.name = KANBackgroundThreadName;
        [self.backgroundThread start];
    } else {
        // ignore message if background thread is already running
        NSLog(@"thread is already running");
    }
}

- (void)performUpdateWithFullUpdate:(NSNumber *)fullUpdate
{
    BOOL fullUpdateFlag = [fullUpdate boolValue];
    
    [self postNotification:KANDataStoreWillBeginUpdatingNotification];
    [self postNotification:KANDataStoreDidBeginUpdatingNotification];
    
    __block BOOL updateSuccessful = YES;
    KANAPI *client = [KANAPI sharedClient];
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    
    // Get last updated date, default to 1970 if no date is saved or full update was requested
    
    NSDate *lastUpdated = [sud objectForKey:KANUserDefaultsLastUpdatedKey];
    NSDate *newLastUpdated = [KANAPI serverTime];
    
    if (fullUpdateFlag || lastUpdated == nil) {
        lastUpdated = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    CJLog(@"using lastUpdated: %@", lastUpdated);
    
    
    // Add/Update tracks
    
    NSUInteger offset = 0;
    NSUInteger trackCount = [KANAPI trackCountWithLastUpdatedAt:lastUpdated];
    
    CJLog(@"track count since last update: %d", trackCount);
    
    NSMutableArray *operations = [[NSMutableArray alloc] initWithCapacity:((trackCount / KANDataStoreFetchLimit) * 2)];
    
    while (offset < trackCount) {
        NSURLRequest *req = [KANAPI tracksRequestWithSQLLimit:KANDataStoreFetchLimit SQLOffset:offset LastUpdatedAt:lastUpdated];
        AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSArray *trackData) {
            CJLog(@"trackData count: %d", [trackData count]);
            [self handleTrackDatas:trackData];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            CJLog(@"%@", error);
            updateSuccessful = NO;
        }];
        
        [operations addObject:op];
        offset += KANDataStoreFetchLimit;
    }
    
    // Delete old tracks
    
    NSURLRequest *req = [KANAPI deletedTracksRequestFromCurrentTracks:[self allTracks]];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSArray *uuids) {
        [self deleteTracksWithUUIDArray:uuids];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        CJLog(@"%@", error);
        updateSuccessful = NO;
    }];
    
    [operations addObject:op];
    
    // Process operations
    
    NSDate *startDate = [NSDate date];
    [client enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        CJLog(@"progress: %d - %d", numberOfFinishedOperations, totalNumberOfOperations);
        NSError *error;
        [self.backgroundManagedObjectContext save:&error];
        if (error)
            CJLog(@"%@", error);
    } completionBlock:^(NSArray *operations) {
        CJLog(@"%@", updateSuccessful ? @"update was successful" : @"update wasn't successful");
        
        if (updateSuccessful) {
            [sud setObject:newLastUpdated forKey:KANUserDefaultsLastUpdatedKey];
            [sud synchronize];
        }

        [self postNotification:KANDataStoreWillFinishUpdatingNotification];
        [self postNotification:KANDataStoreDidFinishUpdatingNotification];
        
        CJLog(@"total update time: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
    }];
}

- (void)deleteTracksWithUUIDArray:(NSArray *)uuids
{
    NSManagedObjectContext *moc = [self managedObjectContextForThread:[NSThread currentThread]];
    NSError *error;

    // fetch old tracks
    NSFetchRequest *deletedTracksReq = [NSFetchRequest fetchRequestWithEntityName:KANTrackEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid in %@", uuids];
    deletedTracksReq.predicate = predicate;
    NSArray *deletedTracks = [moc executeFetchRequest:deletedTracksReq error:&error];
    
    CJLog(@"deletedTracks count: %d", [deletedTracks count]);
    
    // delete old tracks
    for (NSManagedObject *deletedTrack in deletedTracks) {
        [moc deleteObject:deletedTrack];
    }
}

- (NSArray *)allTracks
{
    NSManagedObjectContext *moc = [self managedObjectContextForThread:[NSThread currentThread]];
    
    // get all tracks
    NSFetchRequest *allTracksReq = [NSFetchRequest fetchRequestWithEntityName:KANTrackEntityName];
    allTracksReq.fetchBatchSize = 100;
    
    NSError *error;
    NSArray *tracks = nil;
    
    if (error) {
        CJLog(@"%@", error);
    } else {
        tracks = [moc executeFetchRequest:allTracksReq error:&error];
    }
    
    return tracks;
}


#pragma mark - Core Data Stack

- (NSManagedObjectContext *)mainManagedObjectContext
{
    assert([NSThread isMainThread]);
    
    if (_mainManagedObjectContext == nil) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext
{
    assert([self.backgroundThread.name isEqualToString:KANBackgroundThreadName]);
    
    if (_backgroundManagedObjectContext == nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _backgroundManagedObjectContext;
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
