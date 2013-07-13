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

@implementation KANUtils

+ (NSString *)normalizedStringForString:(NSString *)string
{
    // TODO: replace characters used for stylizing like $ with s before normalizing
    return [CJStringNormalization normalizeString:string];
}

+(NSDate *)dateFromRailsDateString:(NSString *)dateStr
{
    return [[NSDateFormatter rfc3339] dateFromString:dateStr];
}

@end
