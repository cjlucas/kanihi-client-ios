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

// model helpers
+ (NSUInteger)durationForTracks:(id <NSFastEnumeration>)tracks; //set or array of tracks
+ (NSString *)timecodeForDuration:(NSUInteger)duration
                  withZeroPadding:(BOOL)zeroPadding;
+ (NSString *)timecodeForTracks:(id <NSFastEnumeration>)tracks
                withZeroPadding:(BOOL)zeroPadding; // convenience
+ (NSInteger)yearForDate:(NSDate *)date;

// tableview methods
+ (NSString *)sectionTitleForString:(NSString *)string;
+ (NSAttributedString *)boldNumberStringForString:(NSString *)str
                                         withFont:(UIFont *)font;
+ (NSAttributedString *)boldEntityCountStringWithCount:(NSInteger)count
                                      withEntityString:(NSString *)entity
                                              withFont:(UIFont *)font;

@end
