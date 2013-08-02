//
//  KANAudioPlayerViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioPlayerViewController.h"

#import "KANAudioPlayer.h"

#import "KANAlbumTrackListingTableViewController.h"
#import "KANTrack.h"
#import "KANDisc.h"

@interface KANAudioPlayerViewController ()

@end

@implementation KANAudioPlayerViewController

- (void)viewDidLoad
{
    //[[KANAudioPlayer sharedPlayer] setDelegate:self];
}

- (IBAction)playPauseButtonPressed:(id)sender {
    [[KANAudioPlayer sharedPlayer] togglePlayPause];
}

- (IBAction)playPreviousButtonPressed:(id)sender {
    [[KANAudioPlayer sharedPlayer] playPrevious];
}

- (IBAction)playNextButtonPressed:(id)sender {
    [[KANAudioPlayer sharedPlayer] playNext];
}

- (IBAction)showPlaylistButtonPressed:(id)sender {
    CJLog(@"here", nil);
    NSDate *start = [NSDate date];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    KANAlbumTrackListingTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"blahid"];
    KANTrack *current = (KANTrack *)[[KANAudioPlayer sharedPlayer] currentItem];
    vc.album = current.disc.album;
    CJLog(@"%f", [[NSDate date] timeIntervalSinceDate:start]);
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - CJAudioPlayerDelegate methods


@end
