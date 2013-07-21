//
//  KANTableViewCell.m
//  Kanihi
//
//  Created by Chris Lucas on 7/20/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTableViewCell.h"
#import "KANLabelContainerView.h"

#define MAIN_LABEL_FONT_SIZE 16.0
#define DETAIL_LABEL_FONT_SIZE 14.0

@interface KANTableViewCell ()

- (void)updateLabelContainerView;

@end

@implementation KANTableViewCell

@synthesize mainString = _mainString;
@synthesize detailStrings = _detailStrings;

- (NSString *)mainString
{
    return _mainString;
}

- (void)setMainString:(NSString *)mainText
{
    _mainString = mainText;
    
    [self updateLabelContainerView];
}

- (NSArray *)detailStrings
{
    return _detailStrings;
}

- (void)setDetailStrings:(NSArray *)detailTexts
{
    _detailStrings = detailTexts;
    
    [self updateLabelContainerView];
}


- (UILabel *)mainLabel
{
    // set the frame size here so word wrapping can be calculated
    // frame height will be adjusted when added to container view
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.labelContainerView.frame.size.width, 0)];
    
    //label.backgroundColor = [UIColor blueColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:MAIN_LABEL_FONT_SIZE];
    label.numberOfLines = 2;
    //label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    //label.minimumScaleFactor = 0.9;
    
    return label;
}

- (UILabel *)detailLabel
{
    // see notes in mainLabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.labelContainerView.frame.size.width, 0)];
    
    //label.backgroundColor = [UIColor redColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:DETAIL_LABEL_FONT_SIZE];
    label.minimumScaleFactor = 0.9;
    
    return label;
}

- (void)updateLabelContainerView
{
    for (UIView *view in self.labelContainerView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.mainString) {
        UILabel *label = [self mainLabel];
        if ([self.mainString isKindOfClass:[NSString class]])
            label.text = self.mainString;
        else if ([self.mainString isKindOfClass:[NSAttributedString class]])
            label.attributedText = self.mainString;
        
        [self.labelContainerView addSubview:label];
    }
    
    for (id string in self.detailStrings) {
        UILabel *label = [self detailLabel];
        
        if ([string isKindOfClass:[NSString class]])
            label.text = string;
        else if ([string isKindOfClass:[NSAttributedString class]])
            label.attributedText = string;
        
        [self.labelContainerView addSubview:label];
    }
}

@end
