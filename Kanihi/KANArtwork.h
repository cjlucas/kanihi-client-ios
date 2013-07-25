//
//  KANArtwork.h
//  Kanihi
//
//  Created by Chris Lucas on 7/21/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANUniqueEntity.h"

@interface KANArtwork : KANUniqueEntity

@property (nonatomic, retain) NSString *checksum;
@property (nonatomic, retain) NSNumber *artworkType;
@property (nonatomic, retain) NSString *artworkDescription;

@property (nonatomic, retain) NSSet *tracks;

@end
