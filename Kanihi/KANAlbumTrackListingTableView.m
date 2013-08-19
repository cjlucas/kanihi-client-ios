//
//  KANAlbumTrackListingTableView.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTrackListingTableView.h"
#import "KANPlaylistTableViewCell.h"

#import "KANTrack.h"
#import "KANDisc.h"
#import "KANAlbum.h"
#import "KANTrackArtist.h"
#import "KANAlbumArtist.h"

#import "KANAudioPlayer.h"

@interface KANAlbumTrackListingTableView () {
    dispatch_once_t _shouldShowTrackArtistOnceToken;
    BOOL _showTrackArtist; // access via shouldShowTrackArtist
}

- (void)setup;
- (BOOL)shouldShowSectionHeaders;

@end

@implementation KANAlbumTrackListingTableView
@synthesize tracks = _tracks;
@synthesize discs = _discs;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }

    return self;
}

- (void)setup
{
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"KANPlaylistTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"KANPlaylistTableViewCell"];

    _showTrackArtist = NO;
}

- (BOOL)shouldShowSectionHeaders
{
    return self.discs.count > 1;
}

- (BOOL)shouldShowTrackArtist
{
    dispatch_once(&_shouldShowTrackArtistOnceToken, ^{
        for (KANTrack *track in self.album.tracks) {
            if (![track.artist.name isEqualToString:self.album.artist.name]) {
                _showTrackArtist = YES;
                break;
            }
        }
    });

    return _showTrackArtist;
}

- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger discIndex = [indexPath indexAtPosition:0];
    NSUInteger trackIndex = [indexPath indexAtPosition:1];

    // if there are multiple discs, increment trackIndex by the combined number of tracks in the previous discs
    int i = 0;
    while (i < discIndex) {
        KANDisc *disc = self.discs[i];
        trackIndex += disc.tracks.count;
        i++;
    }

    return self.tracks[trackIndex];
}

- (NSArray *)tracks
{
    if (!_tracks) {
        NSMutableArray *__tracks = [[NSMutableArray alloc] initWithCapacity:self.album.tracks.count];
        for (KANDisc *disc in self.discs) {
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
            [__tracks addObjectsFromArray:[disc.tracks sortedArrayUsingDescriptors:@[sorter]]];
        }

        _tracks = [__tracks copy];
    }

    return _tracks;
}

- (NSArray *)discs
{
    if (!_discs) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        _discs = [self.album.discs sortedArrayUsingDescriptors:@[sorter]];
    }

    return _discs;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.discs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((KANDisc *)self.discs[section]).tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: highlight currently playing track

    KANPlaylistTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"KANPlaylistTableViewCell"];

    KANTrack *track = [self trackForIndexPath:indexPath];
    cell.itemNumberLabel.text = [NSString stringWithFormat:@"%@.", track.num];
    cell.timecodeLabel.text = [KANUtils timecodeForDuration:[track.duration integerValue] withZeroPadding:NO];
    cell.mainString = track.name;
    if ([self shouldShowTrackArtist]) {
        cell.detailStrings = @[track.artist.name];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![self shouldShowSectionHeaders])
        return nil;

    KANDisc *disc = self.discs[section];
    NSMutableString *title = [NSMutableString stringWithFormat:@"Disc %@", disc.num];

    if (disc.name)
        [title appendFormat:@" (%@)", disc.name];

    return [title copy];
}

@end
