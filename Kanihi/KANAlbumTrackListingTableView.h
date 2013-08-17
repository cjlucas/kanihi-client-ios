//
//  KANAlbumTrackListingTableView.h
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KANLabelContainerView;

@interface KANAlbumTrackListingTableView : UITableView
@property (weak, nonatomic) IBOutlet UIImageView *insetArtworkView;
@property (weak, nonatomic) IBOutlet KANLabelContainerView *albumInfoLabelContainerView;

@end
