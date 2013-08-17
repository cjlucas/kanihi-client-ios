//
//  KANTrackTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/27/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrackTableViewController.h"
#import "KANTableViewCell.h"

#import "KANArtworkStore.h"
#import "KANTrack.h"
#import "KANDisc.h"
#import "KANAlbum.h"
#import "KANTrackArtist.h"

#import "KANAudioPlayerViewController.h"

@interface KANTrackTableViewController ()

- (id)mainStringForCell:(KANTableViewCell *)cell withTrack:(KANTrack *)track;
- (NSArray *)detailStringsForCell:(KANTableViewCell *)cell withTrack:(KANTrack *)track;
- (void)setArtworkView:(UIImageView *)artworkView withTrack:(KANTrack *)track;

@end

@implementation KANTrackTableViewController

- (NSString *)entityName
{
    return KANTrackEntityName;
}

- (NSString *)sortDescriptorKey
{
    return @"name";
}

- (NSString *)sectionNameKeyPath
{
    return @"sectionTitle";
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.title == nil)
        self.title = @"Tracks";
}

- (id)mainStringForCell:(KANTableViewCell *)cell withTrack:(KANTrack *)track
{
    return track.name;
}

- (NSArray *)detailStringsForCell:(KANTableViewCell *)cell withTrack:(KANTrack *)track
{
    NSMutableArray *detailStrings = [[NSMutableArray alloc] initWithCapacity:2];

    if (track.artist)
        [detailStrings addObject:track.artist.name];

    if (track.disc.album)
        [detailStrings addObject:track.disc.album.name];

    return detailStrings;
}

- (void)setArtworkView:(UIImageView *)artworkView withTrack:(KANTrack *)track
{
    KANArtwork *artwork = [KANArtworkStore artworkForEntity:track];

    [KANArtworkStore attachArtwork:artwork toImageView:artworkView thumbnail:YES];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"KANTableViewCell"
                                                                  forIndexPath:indexPath];

    KANTrack *track = [self.resultsController objectAtIndexPath:indexPath];

    cell.mainString = [self mainStringForCell:cell withTrack:track];
    cell.detailStrings = [self detailStringsForCell:cell withTrack:track];
    [self setArtworkView:cell.artworkView withTrack:track];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANAudioPlayerViewController *vc = [self instantiateAudioPlayerViewController];

    KANTrack *track = [self.resultsController objectAtIndexPath:indexPath];
    
    [KANAudioPlayer setItems:@[track]];
    [[KANAudioPlayer sharedPlayer] playItem:track];

    [self.navigationController pushViewController:vc animated:YES];
}

@end
