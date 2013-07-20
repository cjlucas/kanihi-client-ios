//
//  KANAlbumTrackListingTableViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KANAlbum.h"

@interface KANAlbumTrackListingTableViewController : UITableViewController

- (id)initWithAlbum:(KANAlbum *)album; // designated initializer

@property (readonly) KANAlbum *album;
@property (readonly) NSArray *discs; // sorted array of album.discs; lazy

// 2d array (1st level: discs; 2nd level: tracks for disc)
@property (readonly) NSArray *tracks; // lazy

@end
