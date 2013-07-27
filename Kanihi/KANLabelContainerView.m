//
//  KANLabelContainerView.m
//  Kanihi
//
//  Created by Chris Lucas on 7/20/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANLabelContainerView.h"

@interface KANLabelContainerView ()

@end

@implementation KANLabelContainerView

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [subview sizeToFit];
}
- (void)layoutSubviews
{
    NSInteger numSubviews = [self.subviews count];
    
    if (numSubviews == 0)
        return;
    
    CGFloat containerHeight = self.frame.size.height;
    CGFloat totalSubviewHeight = 0; // sum of heights of all subviews
    CGFloat totalSubviewPadding = 0; // inside + outside padding
    CGFloat insidePadding = 2.0; // padding between siblings
    CGFloat totalInsidePadding = insidePadding * (numSubviews - 1); // used to determine totalOutsidePadding
    CGFloat totalOutsidePadding = 0; // only top half of outside padding is used
    
    for (UIView *subview in self.subviews) {
        totalSubviewHeight += subview.frame.size.height;
    }

    totalSubviewPadding = containerHeight - totalSubviewHeight;
    totalOutsidePadding = totalSubviewPadding - totalInsidePadding;
    
    __block CGFloat nextOriginYPos = totalOutsidePadding / 2; // start with top padding
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect frame = view.frame; // get editable frame
        
        frame.origin.x = 0;
        frame.origin.y = nextOriginYPos;
        frame.size.width = self.frame.size.width;
        
        view.frame = frame; // move view to new origin

        nextOriginYPos += view.frame.size.height + insidePadding;

    }];
}

@end
