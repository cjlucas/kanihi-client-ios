//
//  KANPlaylistDataSource.m
//  Kanihi
//
//  Created by Chris Lucas on 8/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANPlaylistDataSource.h"

#import "KANPlaylistTableViewCell.h"
#import "KANTrack.h"

@implementation KANPlaylistDataSource

@synthesize tracks = _tracks;

- (id)initWithTracks:(NSArray *)tracks
{
    if (self = [super init]) {
        _tracks = [tracks copy];
    }

    return self;
}

- (KANTrack *)trackAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tracks objectAtIndex:[indexPath indexAtPosition:1]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.tracks.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTrack *track = [self trackAtIndexPath:indexPath];

    KANPlaylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KANPlaylistTableViewCell"];

    cell.itemNumberLabel.text = [NSString stringWithFormat:@"%d.", [self.tracks indexOfObject:track] + 1];
    cell.mainString = track.name;
    cell.timecodeLabel.text = [KANUtils timecodeForDuration:[track.duration integerValue] withZeroPadding:NO];

    return cell;
}


@end