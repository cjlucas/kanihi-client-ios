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

@class KANLabelContainerView;

@interface KANAlbumTrackListingViewController : UIViewController <UITableViewDelegate>

@property KANAlbum *album;

@property (weak, nonatomic) IBOutlet UIView *albumTrackListingHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *insetImageView;
@property (weak, nonatomic) IBOutlet KANLabelContainerView *albumInfoLabelContainerView;

@property (weak, nonatomic) IBOutlet KANAlbumTrackListingTableView *tableView;

@end