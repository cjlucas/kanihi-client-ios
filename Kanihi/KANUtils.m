//
//  KANUtils.m
//  Kanihi
//
//  Created by Chris Lucas on 7/13/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANUtils.h"

#import "CJStringNormalization.h"
#import "NSDateFormatter+CJExtensions.h"
#import "NSString+CJExtensions.h"
#import "KANTrack.h"

@implementation KANUtils

+ (NSString *)normalizedStringForString:(NSString *)string
{
    NSString *normalized = [string stringByReplacingOccurrencesOfString:@"$" withString:@"s"];
    return [CJStringNormalization normalizeString:normalized];
}

+ (NSDate *)dateFromRailsDateString:(NSString *)dateStr
{
    return [[NSDateFormatter rfc3339] dateFromString:dateStr];
}

+ (NSString *)sectionTitleForString:(NSString *)string
{
    // gets the first alphanumeric character for the section title
    NSRange titleRange = [string rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
    
    // return an empty string if alphanumeric character couldn't be found
    if (titleRange.location == NSNotFound)
        return @"";
    
    NSString *firstChar = [[string substringWithRange:titleRange] uppercaseString];
    
    // if first alphanumeric character is a number, use # for the section title
    if ([firstChar rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
        return @"#";
    } else {
        return firstChar;
    }
}

+ (NSAttributedString *)boldNumberStringForString:(NSString *)str
                                         withFont:(UIFont *)font;
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    // find first space
    NSRange numberRange = [str rangeOfString:@" "];

    // get bold version of font
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:font.pointSize];
    
    [attrStr addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, numberRange.location)];
    
    return [attrStr copy];
}

+ (NSAttributedString *)boldEntityCountStringWithCount:(NSInteger)count
                                      withEntityString:(NSString *)entity
                                              withFont:(UIFont *)font
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%d %@", count, entity];
    if (count > 1)
        [string appendString:@"s"];
    
    return [self boldNumberStringForString:string withFont:font];
}


+ (NSUInteger)durationForTracks:(id <NSFastEnumeration>)tracks
{
    NSUInteger duration = 0;
    for (KANTrack *track in tracks) {
        duration += track.duration.integerValue;
    }
    
    return duration;
}

+ (NSString *)timecodeForDuration:(NSUInteger)duration
                  withZeroPadding:(BOOL)zeroPadding;
{
    NSUInteger hours;
    NSUInteger minutes;
    NSUInteger seconds;
    NSString *fmtPad = @"%.2d";
    NSString *fmtNoPad = @"%d";
    
    hours = duration / 3600;
    duration = duration % 3600;
    
    minutes = duration / 60;
    seconds = duration % 60;
    
    NSMutableArray *timecodeElements = [[NSMutableArray alloc] init];
    
    NSString *unitFmt = zeroPadding ? fmtPad : fmtNoPad;
    
    if (hours > 0) {
        [timecodeElements addObject:[NSString stringWithFormat:unitFmt, hours]];
        unitFmt = fmtPad; // ensure minutes has zero padding
    }
    
    [timecodeElements addObject:[NSString stringWithFormat:unitFmt, minutes]];
    unitFmt = fmtPad; // ensure seconds has zero padding
    
    [timecodeElements addObject:[NSString stringWithFormat:unitFmt, seconds]];
    
    return [timecodeElements componentsJoinedByString:@":"];
}

+ (NSString *)timecodeForTracks:(id<NSFastEnumeration>)tracks
                withZeroPadding:(BOOL)zeroPadding
{
    return [self timecodeForDuration:[self durationForTracks:tracks]
                     withZeroPadding:zeroPadding];
}

+ (NSInteger)yearForDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSYearCalendarUnit fromDate:date];
    
    return [components year];
}

@end
