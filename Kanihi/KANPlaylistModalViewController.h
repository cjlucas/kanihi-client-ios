//
//  KANAudioPlayerPlaylistTableViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANPlaylistDataSource.h"

@interface KANPlaylistModalViewController : UIViewController <UITableViewDelegate>

@property KANPlaylistDataSource *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)closeButtonPressed:(id)sender;

@end
