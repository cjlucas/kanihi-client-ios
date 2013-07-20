//
//  KANUtils.h
//  Kanihi
//
//  Created by Chris Lucas on 7/13/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KANUtils : NSObject

+ (NSString *)normalizedStringForString:(NSString *)string;
+ (NSDate *)dateFromRailsDateString:(NSString *)dateStr;
+ (NSString *)sectionTitleForString:(NSString *)string;

@end
