//
//  KANAlbumTrackListingTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTrackListingTableViewController.h"
#import "KANAlbumTrackListingTableView.h"
#import "KANAlbumTrackListingCell.h"

#import "KANDisc.h"
#import "KANTrack.h"
#import "KANAlbumArtist.h"

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
    
    KANAlbumTrackListingTableView *tableView = (KANAlbumTrackListingTableView *)self.tableView;
    
    NSString *albumName = self.album.name;
    NSString *albumArtist = self.album.artist.name;
    NSString *albumYear = [NSString stringWithFormat:@"(1900)"]; // TODO: write a method for KANAlbum
    
    NSString *albumInfoRaw = [@[albumName, albumArtist, albumYear] componentsJoinedByString:@"\n"];
    
    NSMutableAttributedString *albumInfoString = [[NSMutableAttributedString alloc] initWithString:albumInfoRaw];
    
    [albumInfoString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]
                            range:NSMakeRange(0, self.album.name.length)];
    
    tableView.albumInfoLabel.attributedText = [albumInfoString copy];
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
    KANTrack *track = [self trackForIndexPath:indexPath];
    
    
}

@end
