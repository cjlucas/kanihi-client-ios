//
//  KANAlbumTrackListingTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTrackListingViewController.h"
#import "KANLabelContainerView.h"

#import "KANTrack.h"
#import "KANAlbumArtist.h"

#import "KANArtworkStore.h"
#import "KANAudioPlayer.h"

@interface KANAlbumTrackListingViewController ()
@end

@implementation KANAlbumTrackListingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.album = self.album;
    self.tableView.rowHeight = [self.tableView shouldShowTrackArtist] ? 60 : 44;

    // TODO: all of this should be moved to KANAlbumTrackListingTableView

    CGRect glassFrame = self.albumTrackListingHeaderView.bounds;
    UIView *glassView = [[UIView alloc] initWithFrame:glassFrame];
    glassView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    [self.albumTrackListingHeaderView insertSubview:glassView belowSubview:self.insetImageView];

    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.albumTrackListingHeaderView.frame.size.height-0.5, self.albumTrackListingHeaderView.frame.size.width, 0.5)];
    bottomBorderView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [self.albumTrackListingHeaderView insertSubview:bottomBorderView aboveSubview:glassView];

    KANArtwork *artwork = [KANArtworkStore artworkForEntity:_album];

    [KANArtworkStore loadArtwork:artwork thumbnail:NO withCompletionHandler:^(UIImage *image) {
        CJLog(@"image: (%f, %f)", image.size.width, image.size.height);

        [KANArtworkStore resizeImage:image toSize:self.insetImageView.frame.size withCompletionHandler:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.insetImageView.image = image;
            });
        }];

        [KANArtworkStore blurArtwork:artwork withCompletionHandler:^(UIImage *blurredImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect blurredImageFrame = self.albumTrackListingHeaderView.bounds;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:blurredImageFrame];

                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = blurredImage;
                imageView.layer.masksToBounds = YES; // prevent subview overflow
                [self.albumTrackListingHeaderView insertSubview:imageView atIndex:0];
            });
        }];

    }];

    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    UIFont *subheaderFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];

    float labelWidth = CGRectGetWidth(self.albumInfoLabelContainerView.frame);

    UILabel *albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    albumNameLabel.numberOfLines = 3;
    albumNameLabel.font = headerFont;
    albumNameLabel.text = self.album.name;
    [self.albumInfoLabelContainerView addSubview:albumNameLabel];

    UILabel *albumArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    albumArtistLabel.font = subheaderFont;
    albumArtistLabel.text = self.album.artist.name;
    [self.albumInfoLabelContainerView addSubview:albumArtistLabel];

    UILabel *albumYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    albumYearLabel.font = subheaderFont;
    albumYearLabel.text = @"May 03, 2013";
    [self.albumInfoLabelContainerView addSubview:albumYearLabel];

    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 0)];
    durationLabel.font = subheaderFont;
    durationLabel.text = [KANUtils timecodeForTracks:self.album.tracks withZeroPadding:NO];
    [self.albumInfoLabelContainerView addSubview:durationLabel];
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AudioPlayer"];

    [KANAudioPlayer setItems:self.tableView.tracks];
    [[KANAudioPlayer sharedPlayer] playItem:[self.tableView trackForIndexPath:indexPath]];

    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
