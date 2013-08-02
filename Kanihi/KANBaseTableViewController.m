//
//  KANTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/13/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANBaseTableViewController.h"

#import "KANTableViewCell.h"
#import "KANNavigationController.h"

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

- (id)init
{
    if (self = [super init]) {
        _resultsController = nil;
    }
    
    return self;
}

- (id)initWithPredicate:(NSPredicate *)predicate
{
    if (self = [self init]) {
        self.fetchRequestPredicate = predicate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // customize table
    
    // prevent toolbar from overlapping the last cell
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.navigationController.toolbar.frame.size.height)];
    self.tableView.rowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"KANTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KANTableViewCell"];
    NSError *error;
    [self.resultsController performFetch:&error];
    
    // watch for data store updates
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

- (BOOL)isRootTableViewController
{
    return self == [(KANNavigationController *)self.navigationController rootTableViewController];
}

- (NSFetchedResultsController *)resultsController
{
    if (_resultsController != nil) {
        return _resultsController;
    }
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    
    // require first sort to be by sectionTitle so table lists properly
    NSSortDescriptor *sectionTitleSorter = [NSSortDescriptor sortDescriptorWithKey:@"sectionTitle" ascending:YES];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self sortDescriptorKey] ascending:YES];
    
    req.predicate = self.fetchRequestPredicate;
    req.fetchBatchSize = 20;
    req.sortDescriptors = @[sectionTitleSorter, sortDescriptor];
    
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

- (KANAudioPlayerViewController *)instantiateAudioPlayerViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSLog(@"%@", sb);

    return [sb instantiateViewControllerWithIdentifier:@"AudioPlayer"];
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


//#pragma mark - UIScrollViewDelegate methods
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    NSLog(@"will end dragging");
//    NSLog(@"velocity: (%f,%f)", velocity.x, velocity.y);
//    NSLog(@"target offset: (%f,%f)", targetContentOffset->x, targetContentOffset->y);
//    
//    if (velocity.y  == 0) // when user taps to stop scrolling
//        [self.navigationController setToolbarHidden:NO animated:YES];
//    else if (velocity.y > 0) // scrolling downward
//        [self.navigationController setToolbarHidden:YES animated:NO];
//    else // scrolling upward
//        [self.navigationController setToolbarHidden:NO animated:NO];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"did end decelerating");
//    [self.navigationController setToolbarHidden:NO animated:YES];
//}


@end
