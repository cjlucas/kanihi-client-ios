//
//  KANAlbumArtistsTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/16/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumArtistsTableViewController.h"
#import "KANAlbumTableViewController.h"

#import "KANConstants.h"
#import "KANAlbumArtist.h"

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    KANAlbumArtist *mo = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = mo.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"omg im here");
    NSLog(@"%@", indexPath);
    
    KANAlbumArtist *mo = [self.resultsController objectAtIndexPath:indexPath];
    
    KANAlbumTableViewController *tvc = [[KANAlbumTableViewController alloc] init];
    
    tvc.fetchRequestPredicate = [NSPredicate predicateWithFormat:@"artist.name = %@", mo.name];
    
    UINavigationController *parentViewController = (UINavigationController *)self.parentViewController;
    
    NSLog(@"count: %d", [[[parentViewController navigationBar] items] count]);
    [parentViewController pushViewController:tvc animated:YES];
}

@end
