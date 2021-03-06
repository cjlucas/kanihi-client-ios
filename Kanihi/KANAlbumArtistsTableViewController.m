//
//  KANAlbumArtistsTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/16/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumArtistsTableViewController.h"
#import "KANAlbumTableViewController.h"
#import "KANTableViewCell.h"

#import "KANAlbumArtist.h"

#import "KANAPI.h"
#import "KANArtworkStore.h"

@class KANAlbum;

@interface KANAlbumArtistsTableViewController ()

@end

@implementation KANAlbumArtistsTableViewController

- (NSString *)entityName
{
    return KANAlbumArtistEntityName;
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
    
    if (self.title == nil)
        self.title = @"Artists";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    KANTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"KANTableViewCell" forIndexPath:indexPath];

    KANAlbumArtist *artist = [self.resultsController objectAtIndexPath:indexPath];
    KANArtwork *artwork = [KANArtworkStore artworkForEntity:artist];

    UIFont *subtitleFont = cell.detailLabel.font;
    
    cell.mainString = artist.name;
    NSAttributedString *albumCount = [KANUtils boldEntityCountStringWithCount:[artist.albums count]
                                                             withEntityString:@"album"
                                                                     withFont:subtitleFont];
    
    NSAttributedString *trackCount = [KANUtils boldEntityCountStringWithCount:[artist.tracks count]
                                                             withEntityString:@"track"
                                                                     withFont:subtitleFont];
    
    [KANArtworkStore attachArtwork:artwork toImageView:cell.artworkView thumbnail:YES];
    
    cell.detailStrings = @[albumCount, trackCount];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANAlbumArtist *mo = [self.resultsController objectAtIndexPath:indexPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist.name = %@", mo.name];
    
    KANAlbumTableViewController *tvc = [[KANAlbumTableViewController alloc] initWithPredicate:predicate];
    
    tvc.title = mo.name;
    
    UINavigationController *parentViewController = (UINavigationController *)self.parentViewController;
    
    [parentViewController pushViewController:tvc animated:YES];
}

@end
