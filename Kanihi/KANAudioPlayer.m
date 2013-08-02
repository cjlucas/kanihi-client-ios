//
//  KANAudioPlayer.m
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAudioPlayer.h"

#import "AudioPlayer.h"
#import "KANTrack.h"

@implementation KANAudioPlayer

+ (KANAudioPlayer *)sharedPlayer
{
    static KANAudioPlayer *_audioPlayer = nil;
    if (!_audioPlayer) {
        _audioPlayer = [[KANAudioPlayer alloc] initWithAudioPlayer:[[AudioPlayer alloc] init]];

        _audioPlayer.albumTitleKeyPath = @"disc.album.name";
        _audioPlayer.artistKeyPath     = @"artist.name";
        _audioPlayer.durationKeyPath   = @"duration";
        _audioPlayer.trackTitleKeyPath = @"name";
    }

    return _audioPlayer;
}

+ (void)setQueue:(NSArray *)items
{
    KANAudioPlayer *player = [self sharedPlayer];
    [player resetQueue];

    for (KANTrack *track in items) {
        [player addItem:track];
    }
}

@end
