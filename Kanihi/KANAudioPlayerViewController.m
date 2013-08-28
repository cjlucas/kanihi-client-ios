//
//  KANAudioPlayerViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioPlayerViewController.h"

#import "KANPlaylistModalViewController.h"

#import "KANTrack.h"
#import "KANArtworkStore.h"
#import "KANAudioPlayer.h"

#import "KANAppDelegate.h"

@interface KANAudioPlayerViewController ()

- (void)updateOutlets;
- (void)updatePlaybackProgressView:(NSTimer *)timer;

@property NSTimer *periodicUpdateTimer;
@property (readonly) KANAudioPlayer *audioPlayer;

@end

@implementation KANAudioPlayerViewController

- (void)dealloc
{
    CJLog(@"omghereeeee", nil);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bottomBlurView.blurFraction = 1;
    self.bottomBlurView.backgroundTintColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.5];

    self.audioPlayer.delegate = self;
    self.periodicUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlaybackProgressView:) userInfo:Nil repeats:YES];
    [self updateOutlets];

    //self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidDisappear:(BOOL)animated
{
    CJLog(@"viewDidDisappear", nil);
    self.audioPlayer.delegate = (KANAppDelegate *)[UIApplication sharedApplication].delegate;
    //self.audioPlayer.delegate = nil;
    //[self.periodicUpdateTimer invalidate];

    [super viewDidDisappear:animated];
}

- (KANAudioPlayer *)audioPlayer
{
    return [KANAudioPlayer sharedPlayer];
}

- (void)updateOutlets
{
    KANTrack *currentTrack  = (KANTrack *)self.audioPlayer.currentItem;
    KANArtwork *artwork     = [KANArtworkStore artworkForEntity:currentTrack];

    [KANArtworkStore loadArtwork:artwork thumbnail:NO withCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            self.bottomBackgroundImageView.image = image;
        });
    }];

    //CJLog(@"%@", currentTrack);
    if (currentTrack) {
        self.trackLabel.text = currentTrack.name;
    }
}

- (void)updatePlaybackProgressView:(NSTimer *)timer
{
    if (self.audioPlayer.progress > 0 && self.audioPlayer.duration > 0) {
        [self.playbackProgressView setProgress:(self.audioPlayer.progress / self.audioPlayer.duration) animated:YES];
    }

    NSString *timeElapsedText       = [KANUtils timecodeForDuration:self.audioPlayer.progress withZeroPadding:NO];
    NSString *timeRemainingText     = [KANUtils timecodeForDuration:(self.audioPlayer.duration - self.audioPlayer.progress) withZeroPadding:NO];
    self.timeElapsedLabel.text      = timeElapsedText;
    self.timeRemainingLabel.text    = [NSString stringWithFormat:@"-%@", timeRemainingText];
}

# pragma mark - UI Actions

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [self.audioPlayer togglePlayPause];
}

- (IBAction)playPreviousButtonPressed:(id)sender {
    [self.audioPlayer playPrevious];
}

- (IBAction)playNextButtonPressed:(id)sender {
    [self.audioPlayer playNext];
}

- (IBAction)showPlaylistButtonPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    UINavigationController *vc = [sb instantiateViewControllerWithIdentifier:@"KANPlaylistModalNavigationController"];
    ((KANPlaylistModalViewController *)vc.topViewController).dataSource = [[KANPlaylistDataSource alloc] initWithTracks:self.audioPlayer.queue];

    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - CJAudioPlayerDelegate methods

- (void)audioPlayer:(CJAudioPlayer *)audioPlayer didStartPlayingItem:(KANTrack *)item isFullyCached:(BOOL)fullyCached
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateOutlets];

        if (fullyCached) {
            [self.downloadProgressView setProgress:1.0 animated:NO];
        }
    });

    [((KANAppDelegate *)[UIApplication sharedApplication].delegate) audioPlayer:audioPlayer didStartPlayingItem:item isFullyCached:fullyCached];
}

- (void)audioPlayerDidFinishPlayingQueue:(CJAudioPlayer *)audioPlayer
{
    [((KANAppDelegate *)[UIApplication sharedApplication].delegate) audioPlayerDidFinishPlayingQueue:audioPlayer];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)audioPlayer:(CJAudioPlayer *)audioPlayer currentItemDidUpdateDownloadProgressWithBytesDownloaded:(NSUInteger)bytesDownloaded bytesExpected:(NSUInteger)bytesExpected
{
    __block float progress = bytesDownloaded / (bytesExpected * 1.0);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadProgressView setProgress:progress animated:YES];
    });
}

- (void)audioPlayerCurrentItemDidFinishDownloading:(CJAudioPlayer *)audioPlayer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadProgressView setProgress:1 animated:YES];
    });
}


@end
