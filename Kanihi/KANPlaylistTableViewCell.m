//
//  KANPlaylistTableViewCell.m
//  Kanihi
//
//  Created by Chris Lucas on 8/18/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANPlaylistTableViewCell.h"

@implementation KANPlaylistTableViewCell

- (UILabel *)mainLabel
{
    UILabel *label = [super mainLabel];

    label.font = [UIFont fontWithName:label.font.fontName size:14.0];
    label.numberOfLines = 1;

    return label;
}

- (UILabel *)detailLabel
{
    UILabel *label = [super detailLabel];
    label.font = [UIFont fontWithName:label.font.fontName size:12.0];

    return label;
}

@end
