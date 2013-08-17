//
//  KANAlbumTrackListingTableViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KANAlbum.h"
#import "KANAlbumTrackListingTableView.h"

@interface KANAlbumTrackListingTableViewController : UITableViewController

@property KANAlbum *album;
@property (readonly) NSArray *discs; // sorted array of album.discs; lazy

// 2d array (1st level: discs; 2nd level: tracks for disc)
@property (readonly) NSArray *tracks; // lazy

@property (nonatomic, retain) KANAlbumTrackListingTableView *tableView;

@end