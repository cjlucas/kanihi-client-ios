//
//  KanihiTests.m
//  KanihiTests
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KANDataStore.h"

#import "KANConstants.h"

@interface KANMockDataStore : KANDataStore

- (NSManagedObjectModel *)managedObjectModel;

- (void)handleTrackDatas:(NSArray *)trackDatas;

@end

@implementation KANMockDataStore

- (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *_managedObjectModel;

    if (_managedObjectModel == nil) {
        NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *_psc = nil;
    if (!_psc) {
        _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [_psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:[NSURL URLWithString:@"memory://datastore"] options:nil error:nil];
    }

    return _psc;
}

@end

@interface KanihiTests : XCTestCase

@property (readonly) KANMockDataStore *dataStore;
@property NSArray *initialData;
@end

@implementation KanihiTests

@synthesize dataStore = _dataStore;

- (void)setUp
{
    [super setUp];
    _dataStore = [[KANMockDataStore alloc] init];

    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];

    NSURL *tracks1 = [testBundle URLForResource:@"tracks1" withExtension:@"json"];
    self.initialData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:tracks1] options:0 error:nil];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)importInitialData
{
    [self.dataStore handleTrackDatas:self.initialData];
}

- (NSArray *)fetchAllEntriesWithEntity:(NSString *)entityName
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityName];
    return [self.dataStore.mainManagedObjectContext executeFetchRequest:req error:nil];
}

# pragma mark - Test Cases

- (void)testImportData
{
    [self importInitialData];

    NSArray *results = [self fetchAllEntriesWithEntity:KANTrackEntityName];

    XCTAssertTrue(results.count == 10);
}

@end
