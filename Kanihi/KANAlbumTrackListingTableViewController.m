//
//  KANAlbumTrackListingTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTrackListingTableViewController.h"
#import "KANAlbumTrackListingCell.h"
#import "KANLabelContainerView.h"

#import "KANDisc.h"
#import "KANTrack.h"
#import "KANAlbumArtist.h"

#import "KANArtworkStore.h"
#import "KANAudioPlayer.h"

@interface KANAlbumTrackListingTableViewController ()

- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldShowSectionHeaders;

@end

@implementation KANAlbumTrackListingTableViewController

@synthesize discs = _discs;
@synthesize tracks = _tracks;
@synthesize album = _album;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _discs = nil;
        _tracks = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: all of this should be moved to KANAlbumTrackListingTableView

    KANArtwork *artwork = [KANArtworkStore artworkForEntity:_album];

    [KANArtworkStore loadArtwork:artwork thumbnail:NO withCompletionHandler:^(UIImage *image) {
        CJLog(@"image: (%f, %f)", image.size.width, image.size.height);

        [KANArtworkStore resizeImage:image toSize:self.tableView.insetArtworkView.frame.size withCompletionHandler:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.insetArtworkView.image = image;
            });
        }];

        [KANArtworkStore blurArtwork:artwork withCompletionHandler:^(UIImage *blurredImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = blurredImage;
                imageView.layer.masksToBounds = YES; // prevent subview overflow
                [self.tableView.tableHeaderView insertSubview:imageView atIndex:0];
            });
        }];


        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *glassView = [[UIView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
            glassView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
            [self.tableView.tableHeaderView insertSubview:glassView belowSubview:self.tableView.insetArtworkView];

            UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.tableHeaderView.frame.size.height, self.tableView.tableHeaderView.frame.size.width, 0.5)];
            bottomBorderView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
            [self.tableView.tableHeaderView insertSubview:bottomBorderView aboveSubview:glassView];
        });
    }];
    
    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    UIFont *subheaderFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];

    float labelWidth = CGRectGetWidth(self.tableView.albumInfoLabelContainerView.frame);

    UILabel *albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    albumNameLabel.numberOfLines = 3;
    albumNameLabel.font = headerFont;
    albumNameLabel.text = self.album.name;
    [self.tableView.albumInfoLabelContainerView addSubview:albumNameLabel];

    UILabel *albumArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    albumArtistLabel.font = subheaderFont;
    albumArtistLabel.text = self.album.artist.name;
    [self.tableView.albumInfoLabelContainerView addSubview:albumArtistLabel];

    UILabel *albumYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    albumYearLabel.font = subheaderFont;
    albumYearLabel.text = @"May 03, 2013";
    [self.tableView.albumInfoLabelContainerView addSubview:albumYearLabel];

    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    durationLabel.font = subheaderFont;
    durationLabel.text = [KANUtils timecodeForTracks:self.album.tracks withZeroPadding:NO];
    [self.tableView.albumInfoLabelContainerView addSubview:durationLabel];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _discs = nil;
    _tracks = nil;
}

- (NSArray *)discs
{
    if (_discs == nil) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        _discs = [self.album.discs sortedArrayUsingDescriptors:@[sorter]];
    }
    
    return _discs;
}

- (NSArray *)tracks
{
    if (_tracks == nil) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        NSMutableArray *discs = [[NSMutableArray alloc] initWithCapacity:[self.discs count]];
        
        for (KANDisc *disc in self.discs) {
            [discs addObject:[disc.tracks sortedArrayUsingDescriptors:@[sorter]]];
        }
        
        _tracks = [discs copy];
    }
    
    return _tracks;
}

- (BOOL)shouldShowSectionHeaders
{
    return self.album.discTotal.intValue > 1;
}

- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger discIndex = [indexPath indexAtPosition:0];
    NSUInteger trackIndex = [indexPath indexAtPosition:1];
    
    return self.tracks[discIndex][trackIndex];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tracks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tracks[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANAlbumTrackListingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[KANAlbumTrackListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    KANTrack *track = [self trackForIndexPath:indexPath];
    
    cell.trackNumLabel.text = [NSString stringWithFormat:@"%@.", track.num];
    cell.trackNameLabel.text = track.name;
    
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

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AudioPlayer"];

    [KANAudioPlayer setItems:self.tracks[0]];
    [[KANAudioPlayer sharedPlayer] playItem:[self trackForIndexPath:indexPath]];

    [self.navigationController pushViewController:vc animated:YES];

}

@end
