//
//  KANTableViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/13/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KANDataStore.h"

@interface KANBaseTableViewController : UITableViewController <UITableViewDataSource>
- (BOOL)isRootTableViewController;
@property (readonly) NSFetchedResultsController *resultsController;
@property NSPredicate *fetchRequestPredicate;
@end
