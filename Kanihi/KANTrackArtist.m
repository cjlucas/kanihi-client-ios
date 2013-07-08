//
//  KANTrackArtist.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTrackArtist.h"
#import "KANTrack.h"


@implementation KANTrackArtist

@dynamic name;
@dynamic nameNormalized;
@dynamic tracks;

- (void)setName:(NSString *)newName
{
    NSLog(@"here1");
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:[newName copy] forKey:@"name"];
    [self didChangeValueForKey:@"name"];
    
    self.nameNormalized = [[self class] normalizedStringForString:newName];
}

@end
