//
//  KANGenreViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANGenreTableViewController.h"
#import "KANTableViewCell.h"

#import "KANGenre.h"
#import "KANAPI.h"
#import "UIImageView+AFNetworking.h"

@interface KANGenreTableViewController ()

- (id)mainStringForCell:(KANTableViewCell *)cell withGenre:(KANGenre *)genre;
- (NSArray *)detailStringsForCell:(KANTableViewCell *)cell withGenre:(KANGenre *)genre;
- (void)setArtworkView:(UIImageView *)artworkView withGenre:(KANGenre *)genre;
@end

@implementation KANGenreTableViewController

#pragma mark - KANBaseTableViewController overrides

- (NSString *)entityName
{
    return KANGenreEntityName;
}

- (NSString *)sortDescriptorKey
{
    return @"name";
}

- (NSString *)sectionNameKeyPath
{
    return @"sectionTitle";
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.title == nil)
        self.title = @"Genres";
}

- (id)mainStringForCell:(KANTableViewCell *)cell withGenre:(KANGenre *)genre
{
    return genre.name;
}

- (NSArray *)detailStringsForCell:(KANTableViewCell *)cell withGenre:(KANGenre *)genre
{
    NSAttributedString *trackCount = [KANUtils boldEntityCountStringWithCount:[genre.tracks count] withEntityString:@"track" withFont:cell.detailLabel.font];
    
    return @[trackCount];
}

- (void)setArtworkView:(UIImageView *)artworkView withGenre:(KANGenre *)genre
{
    KANTrack *track = [genre.tracks anyObject];
    
    [artworkView setImageWithURLRequest:[KANAPI artworkRequestForTrack:track withHeight:160] placeholderImage:nil success:nil failure:nil];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"KANTableViewCell"
                                                                  forIndexPath:indexPath];
    
    KANGenre *genre = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.mainString = [self mainStringForCell:cell withGenre:genre];
    cell.detailStrings = [self detailStringsForCell:cell withGenre:genre];
    [self setArtworkView:cell.artworkView withGenre:genre];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANGenre *genre = [self.resultsController objectAtIndexPath:indexPath];
    
    
}

@end
