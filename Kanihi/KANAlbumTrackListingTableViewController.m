//
//  KANAlbumTrackListingTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTrackListingTableViewController.h"
#import "KANAlbumTrackListingTableView.h"
#import "KANAlbumTrackListingCell.h"

#import "KANDisc.h"
#import "KANTrack.h"
#import "KANAlbumArtist.h"

#import "KANArtworkStore.h"
#import "KANAudioPlayer.h"

@interface KANAlbumTrackListingTableViewController ()

- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldShowSectionHeaders;

@end

@implementation KANAlbumTrackListingTableViewController

@synthesize discs = _discs;
@synthesize tracks = _tracks;
@synthesize album = _album;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _discs = nil;
        _tracks = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [KANArtworkStore loadArtworkFromEntity:self.album thumbnail:NO withCompletionHandler:^(UIImage *image) {
        CJLog(@"image: (%f, %f)", image.size.width, image.size.height);

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // create filtered background image
            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:ciImage forKey:kCIInputImageKey];
            [filter setValue:@3.8f forKey:@"inputRadius"];
            CIImage *result = [filter valueForKey:kCIOutputImageKey]; // 4
            CGImageRef filteredImage = [context createCGImage:result fromRect:[ciImage extent]]; // IMPORTANT: get rect from the original CIImage

            __block UIImage *backgroundImage = [UIImage imageWithCGImage:filteredImage];

            dispatch_async(dispatch_get_main_queue(), ^{
                ((KANAlbumTrackListingTableView *)self.tableView).insetArtworkView.image = image;

                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = backgroundImage;
                imageView.layer.masksToBounds = YES; // prevent subview overflow
                [self.tableView.tableHeaderView insertSubview:imageView atIndex:0];

                UIView *glassView = [[UIView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
                glassView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
                [self.tableView.tableHeaderView insertSubview:glassView aboveSubview:imageView];

                CJLog(@"%@", self.tableView.tableHeaderView.subviews);
            });
        });
    }];

    NSMutableAttributedString *albumInfoString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *newLine = [[NSAttributedString alloc] initWithString:@"\n"];
    
    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    UIFont *subheaderFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    
    NSAttributedString *albumName = [[NSAttributedString alloc] initWithString:self.album.name attributes:@{NSFontAttributeName : headerFont}];
    
    NSAttributedString *albumArtist = [[NSAttributedString alloc] initWithString:self.album.artist.name attributes:@{NSFontAttributeName : subheaderFont}];
    
    NSAttributedString *albumYear = [[NSAttributedString alloc] initWithString:@"May 03, 2013" attributes:@{NSFontAttributeName : subheaderFont}];
    
    NSAttributedString *duration = [[NSAttributedString alloc] initWithString:[KANUtils timecodeForTracks:self.album.tracks withZeroPadding:NO] attributes:@{NSFontAttributeName : subheaderFont}];
    
    [albumInfoString appendAttributedString:albumName];
    [albumInfoString appendAttributedString:newLine];
    [albumInfoString appendAttributedString:albumArtist];
    [albumInfoString appendAttributedString:newLine];
    [albumInfoString appendAttributedString:albumYear];
    [albumInfoString appendAttributedString:newLine];
    [albumInfoString appendAttributedString:duration];
    
    ((KANAlbumTrackListingTableView *)self.tableView).albumInfoLabel.attributedText = [albumInfoString copy];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _discs = nil;
    _tracks = nil;
}

- (NSArray *)discs
{
    if (_discs == nil) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        _discs = [self.album.discs sortedArrayUsingDescriptors:@[sorter]];
    }
    
    return _discs;
}

- (NSArray *)tracks
{
    if (_tracks == nil) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        NSMutableArray *discs = [[NSMutableArray alloc] initWithCapacity:[self.discs count]];
        
        for (KANDisc *disc in self.discs) {
            [discs addObject:[disc.tracks sortedArrayUsingDescriptors:@[sorter]]];
        }
        
        _tracks = [discs copy];
    }
    
    return _tracks;
}

- (BOOL)shouldShowSectionHeaders
{
    return self.album.discTotal.intValue > 1;
}

- (KANTrack *)trackForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger discIndex = [indexPath indexAtPosition:0];
    NSUInteger trackIndex = [indexPath indexAtPosition:1];
    
    return self.tracks[discIndex][trackIndex];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tracks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tracks[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANAlbumTrackListingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[KANAlbumTrackListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    KANTrack *track = [self trackForIndexPath:indexPath];
    
    cell.trackNumLabel.text = [NSString stringWithFormat:@"%@.", track.num];
    cell.trackNameLabel.text = track.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![self shouldShowSectionHeaders])
        return nil;
    
    KANDisc *disc = self.discs[section];
    NSMutableString *title = [NSMutableString stringWithFormat:@"Disc %@", disc.num];
    
    if (disc.name)
        [title appendFormat:@" (%@)", disc.name];
    
    return [title copy];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AudioPlayer"];

    [KANAudioPlayer setQueue:self.tracks[0]];
    [[KANAudioPlayer sharedPlayer] playItem:[self trackForIndexPath:indexPath]];

    [self.navigationController pushViewController:vc animated:YES];

}

@end
