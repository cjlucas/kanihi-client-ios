//
//  KANAudioPlayerViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CJAudioPlayer.h"

@class KANTrack;

@interface KANAudioPlayerViewController : UIViewController <CJAudioPlayerDelegate>
// Actions
- (IBAction)playPauseButtonPressed:(id)sender;
- (IBAction)playPreviousButtonPressed:(id)sender;
- (IBAction)playNextButtonPressed:(id)sender;
- (IBAction)showPlaylistButtonPressed:(id)sender;

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playNextButton;
@property (weak, nonatomic) IBOutlet UIButton *playPrevButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *showPlaylistButton;

@end
