//
//  KANAudioPlayerViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioPlayerViewController.h"

#import "KANAudioPlayer.h"

#import "KANAudioPlayerPlaylistTableViewController.h"
#import "KANTrack.h"
#import "KANDisc.h"

@interface KANAudioPlayerViewController ()

- (void)updateOutlets;

@end

@implementation KANAudioPlayerViewController

- (void)viewDidLoad
{
    [[KANAudioPlayer sharedPlayer] setDelegate:self];
    [self updateOutlets];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[KANAudioPlayer sharedPlayer] setDelegate:nil];
}

- (void)updateOutlets
{
    KANAudioPlayer *player = [KANAudioPlayer sharedPlayer];
    KANTrack *currentTrack = (KANTrack *)player.currentItem;

    //CJLog(@"%@", currentTrack);
    if (currentTrack) {
        self.trackLabel.text = currentTrack.name;
    }
}

# pragma mark - UI Actions

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [[KANAudioPlayer sharedPlayer] togglePlayPause];
}

- (IBAction)playPreviousButtonPressed:(id)sender {
    [[KANAudioPlayer sharedPlayer] playPrevious];
}

- (IBAction)playNextButtonPressed:(id)sender {
    [[KANAudioPlayer sharedPlayer] playNext];
}

- (IBAction)showPlaylistButtonPressed:(id)sender {
    KANAudioPlayerPlaylistTableViewController *vc = [[KANAudioPlayerPlaylistTableViewController alloc] initWithTracks:[[KANAudioPlayer sharedPlayer] queue]];

    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - CJAudioPlayerDelegate methods

- (void)audioPlayer:(CJAudioPlayer *)audioPlayer didStartPlayingItem:(KANTrack *)item isFullyCached:(BOOL)fullyCached
{
    [self updateOutlets];
}


@end
