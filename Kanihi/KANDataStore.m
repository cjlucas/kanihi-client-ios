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


@property (readonly) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation KANDataStore

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

- (void)handleTrackDatas:(NSArray *)trackDatas
{
    for (NSDictionary *trackData in trackDatas) {
        KANTrack *track = [KANTrack uniqueEntityForData:trackData[@"track"]
                                              withCache:nil
                                                context:self.mainManagedObjectContext];
        
        track.artist = [KANTrackArtist uniqueEntityForData:trackData[@"track"]
                                                 withCache:nil
                                                   context:self.mainManagedObjectContext];
        
        track.disc = [KANDisc uniqueEntityForData:trackData[@"track"]
                                        withCache:nil
                                          context:self.mainManagedObjectContext];
        
        track.genre = [KANGenre uniqueEntityForData:trackData[@"track"]
                                          withCache:nil
                                            context:self.mainManagedObjectContext];
    }
}

- (void)updateTracksWithFullUpdate:(BOOL)fullUpdate
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:KANDataStoreWillBeginUpdatingNotification object:self];
    [nc postNotificationName:KANDataStoreDidBeginUpdatingNotification object:self];
    
    NSUInteger offset = 0;
    NSError *error;
    
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdated = [sud objectForKey:KANUserDefaultsLastUpdatedKey];
    
    if (fullUpdate || lastUpdated == nil) {
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
            [self.mainManagedObjectContext save:nil];
            
            if ([trackDatas count] < KANDataStoreFetchLimit) {
                NSLog(@"fetch limit is %d but trackDatas count is %d", KANDataStoreFetchLimit, [trackDatas count]);
                break;
            } else {
                offset += [trackDatas count];
            }
            
            NSLog(@"Loop execution time: %f", [[NSDate date] timeIntervalSince1970] - start);
        }
    }
    
    [sud setObject:[NSDate date] forKey:KANUserDefaultsLastUpdatedKey];
    [sud synchronize];
    
    [nc postNotificationName:KANDataStoreWillFinishUpdatingNotification object:self];
    [nc postNotificationName:KANDataStoreDidFinishUpdatingNotification object:self];
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
