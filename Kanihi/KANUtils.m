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
    NSString *firstChar = [string substringToIndex:1];
    
    if (firstChar.number) {
        return @"#";
    } else {
        return firstChar;
    }
}

@end
