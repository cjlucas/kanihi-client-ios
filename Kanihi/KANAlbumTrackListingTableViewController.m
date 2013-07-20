//
//  KANAlbumTrackListingTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTrackListingTableViewController.h"

#import "KANDisc.h"
#import "KANTrack.h"

@interface KANAlbumTrackListingTableViewController ()

- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldShowSectionHeaders;

@end

@implementation KANAlbumTrackListingTableViewController

@synthesize discs = _discs;
@synthesize tracks = _tracks;
@synthesize album = _album;

- (id)initWithAlbum:(KANAlbum *)album
{
    if (self = [super init]) {
        UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        tableHeader.backgroundColor = [UIColor purpleColor];
        self.tableView.tableHeaderView = tableHeader;
        
        _discs = nil;
        _tracks = nil;
        _album = album;
    }
    
    return self;
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    KANTrack *track = [self trackForIndexPath:indexPath];
    NSString *text = [NSString stringWithFormat:@"%5.0d. %@", track.num.intValue, track.name];
    
    cell.textLabel.text = text;
    
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
