//
//  KANNavigationController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/19/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KANNavigationController : UINavigationController <UINavigationControllerDelegate, UINavigationBarDelegate>

@property (readonly) UITableViewController *rootTableViewController;

@end
