//
//  KANEntity.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANEntity.h"


@implementation KANEntity

+ (NSString *)entityName
{
    return nil;
}

+ (NSCharacterSet *)punctuationAndWhitespaceCharacterSet
{
    static NSMutableCharacterSet *_punctuationAndWhitespaceCharacterSet = nil;
    
    if (_punctuationAndWhitespaceCharacterSet == nil)
    {
        _punctuationAndWhitespaceCharacterSet = [NSMutableCharacterSet whitespaceCharacterSet];
        [_punctuationAndWhitespaceCharacterSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    }
    
    return _punctuationAndWhitespaceCharacterSet;
}

/*
 * This only normalizes non-ASCII characters. Meaning characters like $ (Ke$ha) are not converted as they should be 
 */
+ (NSString *)normalizedStringForString:(NSString *)text
{
    NSString *trimmedString = [text stringByTrimmingCharactersInSet:[self punctuationAndWhitespaceCharacterSet]];
    
    // strip accents
    NSData *asciiData = [trimmedString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *asciiString = [[NSString alloc] initWithData:asciiData encoding:NSASCIIStringEncoding];
    
    return [asciiString lowercaseString];
}

@end
