//
//  KANDataStore.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KANDataStoreUpdateProgressInfo : NSObject

@property (readonly) NSUInteger totalTracks;
@property (readonly) NSUInteger currentTrack;

@end

@interface KANDataStore : NSObject

+ (KANDataStore *)sharedDataStore;
- (void)updateDataStoreDoFullUpdate:(BOOL)fullUpdate;

@property (readonly) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly) KANDataStoreUpdateProgressInfo *progressInfo;

@end
