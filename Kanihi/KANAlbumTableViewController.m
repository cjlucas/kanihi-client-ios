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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];    
    KANAlbumTrackListingTableViewController *tvc = [sb instantiateViewControllerWithIdentifier:@"blahid"];
    
    tvc.album = [self.resultsController objectAtIndexPath:indexPath];
    
    [(UINavigationController *)self.parentViewController pushViewController:tvc animated:YES];
}

@end
