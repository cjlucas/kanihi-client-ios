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

@end
