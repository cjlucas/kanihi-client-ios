//
//  KANInitialImportViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 8/22/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANInitialImportViewController.h"

#import "KANDataStore.h"

@interface KANInitialImportViewController ()

- (void)updateOutlets:(NSTimer *)timer;

@property NSTimer *progressInfoTimer;
@property NSDate *startImportDate;

@end

@implementation KANInitialImportViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[KANDataStore sharedDataStore] updateDataStoreDoFullUpdate:NO];
    self.startImportDate = [NSDate date];
    self.progressInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateOutlets:) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.progressInfoTimer invalidate];

    [super viewDidDisappear:animated];
}

- (void)updateOutlets:(NSTimer *)timer
{
    KANDataStoreUpdateProgressInfo *progressInfo = [KANDataStore sharedDataStore].progressInfo;

    if (progressInfo.currentTrack == 0) {
        self.progressInfoLabel.text = @"Downloading track data";
    } else {
        NSUInteger secondsRemaining = 0;
        NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSinceDate:self.startImportDate];
        float importRate = progressInfo.currentTrack / (timeElapsed * 1.0);

        secondsRemaining = (progressInfo.totalTracks - progressInfo.currentTrack) / importRate;

        self.progressInfoLabel.text = [NSString stringWithFormat:@"Updating: %d of %d tracks. %d seconds remaining", progressInfo.currentTrack, progressInfo.totalTracks, secondsRemaining];
    }

    if (progressInfo.currentTrack == progressInfo.totalTracks) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
