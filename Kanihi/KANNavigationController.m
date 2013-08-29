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
- (BOOL)shouldShowWelcomeViewController;

- (void)setPromptForNavigationItem:(UINavigationItem *)item;

@property (readonly) UIViewController *rootViewController;

@end

@implementation KANNavigationController

@synthesize offlineMode = _offlineMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.navigationBar addGestureRecognizer:gestureRecognizer];

    [[NSNotificationCenter defaultCenter] addObserverForName:KANAPIServerDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *notif) {
        CJLog(@"server became available", nil);
        _offlineMode = NO;
        [self setPromptForNavigationItem:self.navigationBar.topItem];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:KANAPIServerDidBecomeUnavailableNotification object:nil queue:nil usingBlock:^(NSNotification *notif) {
        CJLog(@"server went away", nil);
        _offlineMode = YES;
        [self setPromptForNavigationItem:self.navigationBar.topItem];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self shouldShowWelcomeViewController]) {
        [self performSegueWithIdentifier:@"Welcome" sender:self];
    }
}

- (BOOL)shouldShowWelcomeViewController
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:KANUserDefaultsHostKey] == nil;
}

- (UIViewController *)rootViewController
{
    return self.viewControllers[0];
}

- (UITableViewController *)rootTableViewController
{
    UITableViewController *rootTVC = nil;
    
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:[UITableViewController class]]) {
            rootTVC = (UITableViewController *)vc;
            break;
        }
    }
    
    return rootTVC;
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

- (void)setPromptForNavigationItem:(UINavigationItem *)item
{
    if (_offlineMode)
        item.prompt = @"Offline Mode";
    else
        item.prompt = nil;
}

#pragma mark - UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setPromptForNavigationItem:self.navigationBar.topItem];
}

@end
