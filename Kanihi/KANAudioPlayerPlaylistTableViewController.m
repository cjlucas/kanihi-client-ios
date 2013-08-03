//
//  KANAudioPlayerPlaylistTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioPlayerPlaylistTableViewController.h"

#import "KANTrack.h"
#import "KANAudioPlayer.h"

@interface KANAudioPlayerPlaylistTableViewController ()

@end

@implementation KANAudioPlayerPlaylistTableViewController

- (void)viewDidLoad
{
    UINavigationController *nc = (UINavigationController *)self.presentingViewController;

    float tableHeaderHeight = nc.navigationBar.frame.origin.y + nc.navigationBar.frame.size.height; // hackish

    UINavigationBar *tableHeader = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 0, tableHeaderHeight)];
    UINavigationItem *currentItem = [[UINavigationItem alloc] initWithTitle:@"Current Playlist"];

    currentItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];

    tableHeader.items = @[currentItem];
    self.tableView.tableHeaderView = tableHeader;
}

- (void)dismiss
{
    // message is forwarded to presenting view contoller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTrack *track = [self trackAtIndexPath:indexPath];

    [[KANAudioPlayer sharedPlayer] playItem:track];

    [self dismiss];
}

@end
