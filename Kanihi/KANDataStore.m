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

const char * KANDataStoreBackgroundQueueName = "KANDataStoreBackgroundQueue";

@interface KANDataStore () {
    dispatch_queue_t _background_queue;
}

- (void)setup;

- (void)handleTrackDatas:(NSArray *)trackDatas usingManagedObjectContext:(NSManagedObjectContext *)moc;
- (void)deleteTracksWithUUIDArray:(NSArray *)uuids;
- (NSArray *)allTracks; // returns a batched core data proxy array

- (void)postNotification:(NSString *)notification;
- (void)postNotificationHelper:(NSString *)notification;

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread;

@property (readonly) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly) NSManagedObjectContext *managedObjectContextForCurrentThread;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

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
        [_sharedDataStore setup];
    }
    
    return _sharedDataStore;
}

- (void)setup
{
    _background_queue = dispatch_queue_create(KANDataStoreBackgroundQueueName, DISPATCH_QUEUE_SERIAL);
}

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread
{
    return [thread isMainThread] ? self.mainManagedObjectContext : self.backgroundManagedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContextForCurrentThread
{
    return [self managedObjectContextForThread:[NSThread currentThread]];
}

- (void)handleTrackDatas:(NSArray *)trackDatas usingManagedObjectContext:(NSManagedObjectContext *)moc
{
    for (NSDictionary *trackData in trackDatas) {
        KANTrack *track = (KANTrack *)[KANTrack uniqueEntityForData:trackData[@"track"] withCache:nil context:moc];
        
        track.artist    = [KANTrackArtist uniqueEntityForData:trackData[@"track"] withCache:nil context:moc];
        track.disc      = [KANDisc uniqueEntityForData:trackData[@"track"] withCache:nil context:moc];
        track.genre     = [KANGenre uniqueEntityForData:trackData[@"track"] withCache:nil context:moc];
        
        NSMutableSet *artworks = [track mutableSetValueForKey:@"artworks"]; // core data proxy set
        
        // ensure artwork isn't already in track.artworks by doing a checksum lookup before adding
        NSMutableSet *checksums = [[NSMutableSet alloc] initWithCapacity:artworks.count];
        for (KANArtwork *artwork in artworks)
            [checksums addObject:[artwork.checksum lowercaseString]];
        
        for (NSDictionary *artworkData in trackData[@"track"][KANTrackArtworkKey]) {
            KANArtwork *artwork = [KANArtwork uniqueEntityForData:artworkData[KANArtworkKey] withCache:nil context:moc];
            
            if (![checksums containsObject:[artwork.checksum lowercaseString]])
                [artworks addObject:artwork];
        }
    }
}

- (void)updateDataStoreDoFullUpdate:(BOOL)fullUpdate
{
    [self postNotification:KANDataStoreWillBeginUpdatingNotification];
    [self postNotification:KANDataStoreDidBeginUpdatingNotification];
    
    __block BOOL updateSuccessful = YES;
    KANAPI *client = [KANAPI sharedClient];
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    
    // Get last updated date, default to 1970 if no date is saved or full update was requested
    
    NSDate *lastUpdated = [sud objectForKey:KANUserDefaultsLastUpdatedKey];
    NSDate *newLastUpdated = [KANAPI serverTime];
    
    if (fullUpdate || lastUpdated == nil) {
        lastUpdated = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    CJLog(@"using lastUpdated: %@", lastUpdated);

    void (^operationFailureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *error) {
        updateSuccessful = NO;
    };

    // Add/Update tracks
    
    NSUInteger offset = 0;
    NSUInteger trackCount = [KANAPI trackCountWithLastUpdatedAt:lastUpdated];

    void (^updateTracksSuccessBlock)(AFHTTPRequestOperation *op, id) = ^(AFHTTPRequestOperation *op, NSArray *trackData) {
        CJLog(@"trackData count: %d", [trackData count]);
        NSDate *start = [NSDate date];

        @autoreleasepool {
            NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
            moc.undoManager = nil;

            [self handleTrackDatas:trackData usingManagedObjectContext:moc];

            NSError *error;
            [moc save:&error];

            if (error)
                CJLog(@"%@", error);
        }

        CJLog(@"block execution time: %f", [[NSDate date] timeIntervalSinceDate:start]);
    };

    CJLog(@"track count since last update: %d", trackCount);

    NSMutableArray *operations = [[NSMutableArray alloc] initWithCapacity:((trackCount / KANDataStoreFetchLimit) * 2)];
    
    while (offset < trackCount) {
        NSURLRequest *req = [KANAPI tracksRequestWithSQLLimit:KANDataStoreFetchLimit SQLOffset:offset LastUpdatedAt:lastUpdated];
        
        AFJSONRequestOperation *op = (AFJSONRequestOperation *)[client HTTPRequestOperationWithRequest:req success:updateTracksSuccessBlock failure:operationFailureBlock];
        op.successCallbackQueue = _background_queue;
        op.failureCallbackQueue = _background_queue;
        
        [operations addObject:op];
        offset += KANDataStoreFetchLimit;
    }
    
    // Delete old tracks

    void (^deleteTracksSuccessBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, NSDictionary *json) {
        //CJLog(@"%f", [[NSDate date] timeIntervalSince1970]);

        [self deleteTracksWithUUIDArray:json[KANAPIDeletedTracksResponseJSONKey]];

        NSError *error;
        [self.managedObjectContextForCurrentThread save:&error];
        if (error)
            CJLog(@"%@", error);
    };

    for (NSURLRequest *req in [KANAPI deletedTracksRequestsWithCurrentTracks:[self allTracks]]) {
        AFJSONRequestOperation *op = (AFJSONRequestOperation *)[client HTTPRequestOperationWithRequest:req success:deleteTracksSuccessBlock failure:operationFailureBlock];

        [op setQueuePriority:NSOperationQueuePriorityVeryLow];
        op.successCallbackQueue = _background_queue;
        op.failureCallbackQueue = _background_queue;
        [operations addObject:op];
    }

    
    // Process operations
    
    NSDate *startDate = [NSDate date];
    
    void (^progressBlock)(NSUInteger, NSUInteger) = ^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        CJLog(@"progress: %d/%d", numberOfFinishedOperations, totalNumberOfOperations);
    };
    
    void (^completionBlock)(NSArray *) = ^(NSArray *operations) {
        CJLog(@"%@", updateSuccessful ? @"update was successful" : @"update wasn't successful");
        
        if (updateSuccessful) {
            [sud setObject:newLastUpdated forKey:KANUserDefaultsLastUpdatedKey];
            [sud synchronize];
        }
        
        [self postNotification:KANDataStoreWillFinishUpdatingNotification];
        [self postNotification:KANDataStoreDidFinishUpdatingNotification];
        
        CJLog(@"total update time: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
    };
    
    [client enqueueBatchOfHTTPRequestOperations:operations progressBlock:progressBlock completionBlock:completionBlock];
}

- (void)deleteTracksWithUUIDArray:(NSArray *)uuids
{
    NSManagedObjectContext *moc = self.managedObjectContextForCurrentThread;
    NSError *error;

    // fetch old tracks
    NSFetchRequest *deletedTracksReq = [NSFetchRequest fetchRequestWithEntityName:KANTrackEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid IN %@", uuids];
    deletedTracksReq.predicate = predicate;
    NSArray *deletedTracks = [moc executeFetchRequest:deletedTracksReq error:&error];
    
    CJLog(@"deletedTracks count: %d", [deletedTracks count]);
    
    if (error)
        CJLog(@"%@", error);
    
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
    assert(strcmp(dispatch_queue_get_label(_background_queue), KANDataStoreBackgroundQueueName) == 0);
    
    if (_backgroundManagedObjectContext == nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _backgroundManagedObjectContext.undoManager = nil;
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
