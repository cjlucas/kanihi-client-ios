//
//  KANAudioPlayer.h
//  Kanihi
//
//  Created by Chris Lucas on 8/2/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "CJAudioPlayer.h"

@interface KANAudioPlayer : CJAudioPlayer
+ (KANAudioPlayer *)sharedPlayer;
+ (void)setQueue:(NSArray *)items;
@end
