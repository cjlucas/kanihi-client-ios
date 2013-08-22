//
//  KANWelcomeViewController.h
//  Kanihi
//
//  Created by Chris Lucas on 7/26/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KANWelcomeViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UILabel *connectabilityLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

- (IBAction)connectButtonPressed:(id)sender;
@end
