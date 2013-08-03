//
//  KANTableViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/13/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KANDataStore.h"

#import "KANAudioPlayer.h"

@class KANAudioPlayerViewController;

@interface KANBaseTableViewController : UITableViewController {
    BOOL _useFetchedResultsController; // disable if handling table data manually (default: YES)
}

// methods used by resultsController property
- (NSString *)entityName;
- (NSString *)sortDescriptorKey;
- (NSString *)sectionNameKeyPath;
- (NSString *)cacheName;

- (id)initWithPredicate:(NSPredicate *)predicate;
- (BOOL)isRootTableViewController;
- (KANAudioPlayerViewController *)instantiateAudioPlayerViewController;

@property (readonly) NSFetchedResultsController *resultsController;
@property NSPredicate *fetchRequestPredicate;
@end
