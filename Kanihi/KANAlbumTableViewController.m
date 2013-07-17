//
//  KANAlbumTableViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/16/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANAlbumTableViewController.h"

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

@end
