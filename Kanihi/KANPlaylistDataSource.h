//
//  KANPlaylistDataSource.h
//  Kanihi
//
//  Created by Chris Lucas on 8/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KANTrack;

@interface KANPlaylistDataSource : NSObject <UITableViewDataSource>

- (id)initWithTracks:(NSArray *)tracks;
- (KANTrack *)trackAtIndexPath:(NSIndexPath *)indexPath;

@property (readonly) NSArray *tracks;
@end
