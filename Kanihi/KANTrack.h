//
//  KANTrack.h
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "KANEntity.h"
#import "KANUniqueEntity.h"

#import "CJDataSourceQueueManager.h"

@class KANTrackArtist, KANDisc, KANGenre;

@interface KANTrack : KANUniqueEntity <KANUniqueEntityProtocol, CJAudioPlayerQueueItem>

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * lyrics;
@property (nonatomic, retain) NSString * mood;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) NSString * normalizedName;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSDate * originalDate;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * uuid;

// relationships
@property (nonatomic, retain) KANTrackArtist *artist;
@property (nonatomic, retain) KANDisc *disc;
@property (nonatomic, retain) KANGenre *genre;
@property (nonatomic, retain) NSSet *artworks;

@end
