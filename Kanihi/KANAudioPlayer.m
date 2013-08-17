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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _audioPlayer = [[KANAudioPlayer alloc] init];
    });

    return _audioPlayer;
}

+ (void)setItems:(NSArray *)items
{
    KANAudioPlayer *player = [self sharedPlayer];
    [player resetItems];

    for (KANTrack *track in items) {
        [player addItem:track];
    }
}

@end
