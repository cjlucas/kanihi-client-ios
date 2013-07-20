//
//  KANCollectionViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANMainMenuViewController.h"
#import "KANMainMenuViewCell.h"

#import "KANAlbumArtistsTableViewController.h"
#import "KANAlbumTableViewController.h"
#import "KANGenreTableViewController.h"

@interface KANMainMenuViewController ()

- (UIViewController *)tableViewControllerForIndexPath:(NSIndexPath *)indexPath;

@property NSArray *items;

@end

@implementation KANMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = @[@"Artists", @"Albums", @"Genres"];
}

// TODO: refactor the hell out of this
- (UIViewController *)tableViewControllerForIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    
    switch (indexPath.item) {
        case 0:
            vc = [[KANAlbumArtistsTableViewController alloc] init];
            break;
        case 1:
            vc = [[KANAlbumTableViewController alloc] init];
            break;
        case 2:
            vc = [[KANGenreTableViewController alloc] init];
            break;
        default:
            break;
    }
    
    return vc;
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KANMainMenuViewCell *cell = (KANMainMenuViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[KANMainMenuViewCell alloc] init];
    }
    NSLog(@"%f", cell.frame.size.width);
    cell.label.text = self.items[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KANBaseTableViewController *tvc = [self tableViewControllerForIndexPath:indexPath];
    
    [(UINavigationController *)self.parentViewController pushViewController:tvc animated:YES];
}

@end
