//
//  KANPlaylistTableViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANBaseTableViewController.h"

#import "KANTrack.h"

@interface KANPlaylistTableViewController : KANBaseTableViewController

- (id)initWithTracks:(NSArray *)tracks;

- (KANTrack *)trackAtIndexPath:(NSIndexPath *)indexPath;

@end
