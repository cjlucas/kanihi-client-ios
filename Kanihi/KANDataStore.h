//
//  KANDataStore.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KANTrack.h"

@interface KANDataStore : NSObject

+ (KANDataStore *)sharedDataStore;
- (void)doStuff;

@property (readonly) NSManagedObjectContext *mainManagedObjectContext;

@end
