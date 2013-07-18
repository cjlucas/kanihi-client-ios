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

#import "KANConstants.h"
#import "KANAPI.h"

#import "KANTrack.h"
#import "KANTrackArtist.h"
#import "KANDisc.h"
#import "KANGenre.h"

@interface KANDataStore ()
- (void)handleTrackDatas:(NSArray *)trackDatas;
- (void)postNotification:(NSString *)notification;
- (void)postNotificationHelper:(NSString *)notification;
- (void)performUpdateWithFullUpdate:(NSNumber *)fullUpdate;
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
    
    NSUInteger offset = 0;
    NSError *error;
    
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdated = [sud objectForKey:KANUserDefaultsLastUpdatedKey];
    NSDate *newLastUpdated = [KANAPI serverTime];
    
    if (fullUpdateFlag || lastUpdated == nil) {
        lastUpdated = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    NSLog(@"using lastUpdated: %@", lastUpdated);
    
    while (YES) {
        @autoreleasepool {
            NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
            NSLog(@"offset: %d", offset);
            NSURLRequest *req = [KANAPI tracksRequestWithSQLLimit:KANDataStoreFetchLimit
                                                        SQLOffset:offset
                                                    LastUpdatedAt:lastUpdated];
            
            NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
            
            //        if (error != nil) {
            //            CJLog(@"NSURLConnection Error: %s", @"");
            //        }
            
            NSArray *trackDatas = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:nil];
            
            [self handleTrackDatas:trackDatas];
            [self.backgroundManagedObjectContext save:nil];
            
            if ([trackDatas count] < KANDataStoreFetchLimit) {
                NSLog(@"fetch limit is %d but trackDatas count is %d", KANDataStoreFetchLimit, [trackDatas count]);
                break;
            } else {
                offset += [trackDatas count];
            }
            
            NSLog(@"Loop execution time: %f", [[NSDate date] timeIntervalSince1970] - start);
        }
    }
    
    [sud setObject:newLastUpdated forKey:KANUserDefaultsLastUpdatedKey];
    [sud synchronize];
    
    [self postNotification:KANDataStoreWillFinishUpdatingNotification];
    [self postNotification:KANDataStoreDidFinishUpdatingNotification];
}

- (void)deleteOldTracks
{
    NSManagedObjectContext *moc = [self managedObjectContextForThread:[NSThread currentThread]];
    
    // get all tracks
    NSFetchRequest *allTracksReq = [NSFetchRequest fetchRequestWithEntityName:KANTrackEntityName];
    allTracksReq.fetchBatchSize = 100;
    
    NSError *error;
    NSArray *tracks = [moc executeFetchRequest:allTracksReq error:&error];
    
    // get old tracks
    NSArray *oldTracks = [KANAPI deletedTracksFromCurrentTracks:tracks];
    
    NSFetchRequest *deletedTracksReq = [NSFetchRequest fetchRequestWithEntityName:KANTrackEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid in %@", oldTracks];
    deletedTracksReq.predicate = predicate;
    
    NSArray *deletedTracks = [moc executeFetchRequest:deletedTracksReq error:&error];
    NSLog(@"deletedTracks count: %d", [deletedTracks count]);
    // delete old tracks
    for (NSManagedObject *deletedTrack in deletedTracks) {
        [moc deleteObject:deletedTrack];
    }
    
    [moc save:&error];
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
