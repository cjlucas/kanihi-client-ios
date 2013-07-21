//
//  KANTableViewCell.h
//  Kanihi
//
//  Created by Chris Lucas on 7/20/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KANLabelContainerView;

@interface KANTableViewCell : UITableViewCell

// can be NSString or NSAttributedString
@property id mainString;
@property NSArray *detailStrings;

@property (readonly) UILabel *mainLabel;
@property (readonly) UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet KANLabelContainerView *labelContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkView;

@end
