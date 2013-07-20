//
//  KANGenreViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANGenreTableViewController.h"

#import "KANGenre.h"
#import "KANConstants.h"

@interface KANGenreTableViewController ()

@end

@implementation KANGenreTableViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    KANGenre *genre = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = genre.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KANGenre *genre = [self.resultsController objectAtIndexPath:indexPath];
    
    
}

@end
