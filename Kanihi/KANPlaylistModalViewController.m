//
//  KANAudioPlayerPlaylistTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANPlaylistModalViewController.h"

#import "KANTrack.h"
#import "KANAudioPlayer.h"

@interface KANPlaylistModalViewController ()

@end

@implementation KANPlaylistModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 44;
    self.tableView.dataSource = self.dataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"KANPlaylistTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KANPlaylistTableViewCell"];
}

- (void)dismiss
{
    // message is forwarded to presenting view contoller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self dismiss];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTrack *track = [self.dataSource trackAtIndexPath:indexPath];
    [[KANAudioPlayer sharedPlayer] playItem:track];

    [self dismiss];
}

@end
