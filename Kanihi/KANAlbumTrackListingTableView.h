//
//  KANAlbumTrackListingTableView.h
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KANAlbum;
@class KANTrack;

@interface KANAlbumTrackListingTableView : UITableView <UITableViewDataSource>
- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldShowTrackArtist;

@property KANAlbum *album;
@property (readonly) NSArray *tracks;
@property (readonly) NSArray *discs;
@end
