//
//  KANTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/13/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANBaseTableViewController.h"
#import "KANConstants.h"
#import "KANAlbumArtist.h"

@interface KANBaseTableViewController ()

- (NSString *)entityName;
- (NSString *)sortDescriptorKey;
- (NSString *)sectionNameKeyPath;
- (NSString *)cacheName;

- (void)refreshTableData;

- (BOOL)shouldShowSections;
@end

@implementation KANBaseTableViewController

@synthesize resultsController = _resultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    [self.resultsController performFetch:&error];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData) name:KANDataStoreDidFinishUpdatingNotification object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KANDataStoreDidFinishUpdatingNotification object:nil];
    
    [super viewDidUnload];
}

- (void)refreshTableData
{
    if ([self.resultsController performFetch:nil]) {
        [self.tableView reloadData];
    }
}

- (NSFetchedResultsController *)resultsController
{
    if (_resultsController != nil) {
        return _resultsController;
    }
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[self sortDescriptorKey] ascending:YES];
    
    req.predicate = self.fetchRequestPredicate;
    req.fetchLimit = 20;
    req.sortDescriptors = @[sortDescriptor];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                             managedObjectContext:[[KANDataStore sharedDataStore] mainManagedObjectContext]
                                                               sectionNameKeyPath:[self sectionNameKeyPath]
                                                                        cacheName:[self cacheName]];
    
    return _resultsController;
}


- (NSString *)entityName
{
    [NSException raise:@"entityName method not implemented" format:nil];
    return nil;
}

- (NSString *)sortDescriptorKey
{
    return nil;
}

- (NSString *)sectionNameKeyPath
{
    return nil;
}

- (NSString *)cacheName
{
    return nil;
}

- (BOOL)shouldShowSections
{
    // This should be good enough for most entities, unless we're listing albums from a specific genre which could have a lot of albums
    return self.fetchRequestPredicate == nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.resultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.resultsController.sections count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.resultsController.sections objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
         return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:@"tableView:cellForRowAtIndexPath: is not implemented" format:nil];
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:section];
    
    return [self shouldShowSections] ? [sectionInfo name] : nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self shouldShowSections] ? [self.resultsController sectionIndexTitles] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.resultsController sectionForSectionIndexTitle:title atIndex:index];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end