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


@interface KANTrack : KANUniqueEntity <KANUniqueEntityProtocol>

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * lyrics;
@property (nonatomic, retain) NSString * mood;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSDate * originalDate;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSManagedObject *artist;
@property (nonatomic, retain) NSManagedObject *disc;
@property (nonatomic, retain) NSManagedObject *genre;

@end
