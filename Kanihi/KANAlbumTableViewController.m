//
//  KANAlbumTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/16/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTableViewController.h"
#import "KANTableViewCell.h"

#import "KANAlbumTrackListingViewController.h"
#import "KANAlbum.h"
#import "KANAPI.h"
#import "KANTrack.h"
#import "KANAlbumArtist.h"

#import "KANArtworkStore.h"

@interface KANAlbumTableViewController ()

- (id)mainStringForCell:(KANTableViewCell *)cell
              withAlbum:(KANAlbum *)album;
- (NSArray *)detailStringsForCell:(KANTableViewCell *)cell
                        WithAlbum:(KANAlbum *)album;
- (void)setArtworkView:(UIImageView *)artworkView
             withAlbum:(KANAlbum *)album;
@end

@implementation KANAlbumTableViewController

- (NSString *)entityName
{
    return KANAlbumEntityName;
}

- (NSString *)sortDescriptorKey
{
    return @"name";
}

- (NSString *)sectionNameKeyPath
{
    return @"sectionTitle";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // default title
    if (self.title == nil)
        self.title = @"Albums";
}

- (id)mainStringForCell:(KANTableViewCell *)cell withAlbum:(KANAlbum *)album
{
    KANTrack *track = [album.tracks lastObject];

    NSString *albumYearString = [NSString stringWithFormat:@"(%d)", [KANUtils yearForDate:track.date]];
    NSAttributedString *albumYear = [[NSAttributedString alloc] initWithString:albumYearString
                                                                    attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.detailLabel.font.pointSize]}];
    
    NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", album.name]]; // note the space
    [mainString appendAttributedString:albumYear];
    
    return mainString;
}

- (NSArray *)detailStringsForCell:(KANTableViewCell *)cell WithAlbum:(KANAlbum *)album
{
    NSMutableArray *detailStrings = [[NSMutableArray alloc] init];
    
    NSAttributedString *trackCount = [KANUtils boldEntityCountStringWithCount:[album.tracks count]
                                                             withEntityString:@"track"
                                                                     withFont:cell.detailLabel.font];
    
    if ([self isRootTableViewController]) {
        [detailStrings addObject:album.artist.name];
    }
    
    [detailStrings addObject:trackCount];
    
    
    return [detailStrings copy];
}

- (void)setArtworkView:(UIImageView *)artworkView withAlbum:(KANAlbum *)album
{
    KANTrack *track = [album.tracks lastObject];
    KANArtwork *artwork = [KANArtworkStore artworkForEntity:track];

    [KANArtworkStore attachArtwork:artwork toImageView:artworkView thumbnail:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"KANTableViewCell"
                                                                  forIndexPath:indexPath];
    
    KANAlbum *album = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.mainString = [self mainStringForCell:cell withAlbum:album];
    cell.detailStrings = [self detailStringsForCell:cell WithAlbum:album];
    [self setArtworkView:cell.artworkView withAlbum:album];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KANAlbumTrackListingViewController *tvc = [sb instantiateViewControllerWithIdentifier:@"KANAlbumTrackListingTableViewController"];
    
    tvc.album = [self.resultsController objectAtIndexPath:indexPath];
    
    [(UINavigationController *)self.parentViewController pushViewController:tvc animated:YES];
}

@end
