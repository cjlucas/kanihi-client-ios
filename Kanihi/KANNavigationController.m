//
//  KANNavigationController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANNavigationController.h"

@interface KANNavigationController ()

- (void)handleGesture:(UIGestureRecognizer *)gesture;
- (BOOL)shouldPopToRootViewController:(UIGestureRecognizer *)gesture;

@property (readonly) UIViewController *rootViewController;

@end

@implementation KANNavigationController

- (UIViewController *)rootViewController
{
    return self.viewControllers[0];
}

/*
 * gestureLocation: the location within the navigation bar
 */
- (BOOL)shouldPopToRootViewController:(UIGestureRecognizer *)gesture
{
    // if already at root view controller
    if (self.visibleViewController == self.rootViewController)
        return NO;
    
    // if gesture wasn't performed on the left side of the nav bar
    // (if we ever decide to use a uiview for the back button, we can
    // precisely measure whether the gesture was performed on the back button)
    if ([gesture locationInView:self.navigationBar].x > (self.navigationBar.frame.size.width/3))
        return NO;
    
    return YES;
}

- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    if ([self shouldPopToRootViewController:gesture]) {
        [self popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    [self.navigationBar addGestureRecognizer:gestureRecognizer];
}

@end
