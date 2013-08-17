//
//  KANPlaylistTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANPlaylistTableViewController.h"

@interface KANPlaylistTableViewController () {
    NSArray *_tracks;
}

@end

@implementation KANPlaylistTableViewController

- (id)initWithTracks:(NSArray *)tracks
{
    if (self = [super init]) {
        _useFetchedResultsController = NO;
        _tracks = tracks;
    }

    return self;
}

- (KANTrack *)trackAtIndexPath:(NSIndexPath *)indexPath
{
    return [_tracks objectAtIndex:[indexPath indexAtPosition:1]];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _tracks.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTrack *track = [self trackAtIndexPath:indexPath];

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BlahCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlahCell"];
    }

    cell.textLabel.text = track.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [KANAudioPlayer setItems:_tracks];

    KANTrack *track = [self trackAtIndexPath:indexPath];
    [[KANAudioPlayer sharedPlayer] playItem:track];
}


@end
