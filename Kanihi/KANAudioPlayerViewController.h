//
//  KANAudioPlayerViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/30/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CJAudioPlayer.h"
#import "MDBlurView.h"
#import "KANLabelContainerView.h"

@class KANTrack;

@interface KANAudioPlayerViewController : UIViewController <CJAudioPlayerDelegate>
// Actions
- (IBAction)playPauseButtonPressed:(id)sender;
- (IBAction)playPreviousButtonPressed:(id)sender;
- (IBAction)playNextButtonPressed:(id)sender;
- (IBAction)showPlaylistButtonPressed:(id)sender;

// Outlets
@property (weak, nonatomic) IBOutlet KANLabelContainerView *nowPlayingInfoLabelContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBackgroundImageView;
@property (weak, nonatomic) IBOutlet MDBlurView *bottomBlurView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playNextButton;
@property (weak, nonatomic) IBOutlet UIButton *playPrevButton;
@property (weak, nonatomic) IBOutlet UIButton *showPlaylistButton;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *playbackProgressView;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;

@end
