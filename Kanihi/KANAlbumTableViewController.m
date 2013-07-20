//
//  KANAlbumTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/16/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTableViewController.h"

#import "KANAlbumTrackListingTableViewController.h"
#import "KANAlbum.h"
#import "KANConstants.h"

@interface KANAlbumTableViewController ()

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    KANAlbum *mo = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = mo.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANAlbum *album = [self.resultsController objectAtIndexPath:indexPath];
    
    KANAlbumTrackListingTableViewController *tvc = [[KANAlbumTrackListingTableViewController alloc] initWithAlbum:album];
    
    [(UINavigationController *)self.parentViewController pushViewController:tvc animated:YES];
}

@end
