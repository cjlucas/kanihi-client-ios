//
//  KANAudioPlayerViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioPlayerViewController.h"

#import "CJDataSourceQueueManager.h"
#import "AudioPlayer.h"

@interface KANAudioPlayerViewController ()

+ (CJDataSourceQueueManager *)sharedQueueManager;

- (CJDataSourceQueueManager *)sharedQueueManager;

@end

@implementation KANAudioPlayerViewController

+ (CJDataSourceQueueManager *)sharedQueueManager
{
    static CJDataSourceQueueManager *_queueManager = nil;
    if (!_queueManager) {
        _queueManager = [[CJDataSourceQueueManager alloc] initWithAudioPlayer:[[AudioPlayer alloc] init]];
        _queueManager.albumTitleKeyPath = @"disc.album.name";
        _queueManager.artistKeyPath     = @"artist.name";
        _queueManager.durationKeyPath   = @"duration";
        _queueManager.trackTitleKeyPath = @"name";
    }

    return _queueManager;
}

- (CJDataSourceQueueManager *)sharedQueueManager
{
    return [[self class] sharedQueueManager];
}

- (void)setQueue:(NSArray *)items
{
    CJLog(@"%@", items);
    CJDataSourceQueueManager *manager = [[self class] sharedQueueManager];

    [manager resetQueue];

    for (id <CJAudioPlayerQueueItem> item in items)
        [manager addItem:item];
}

- (void)setSelectedItem:(id<CJAudioPlayerQueueItem>)item
{
    [[self sharedQueueManager] playItem:item];
}

- (IBAction)playPauseButtonPressed:(id)sender {
    [[[self class] sharedQueueManager] togglePlayPause];
}

- (IBAction)playPreviousButtonPressed:(id)sender {
    [[self sharedQueueManager] playPrevious];
}

- (IBAction)playNextButtonPressed:(id)sender {
    [[self sharedQueueManager] playNext];
}
@end
