//
//  KANWelcomeViewController.m
//  Kanihi
//
//  Created by Chris Lucas on 7/26/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANWelcomeViewController.h"
#import "KANAPI.h"

@interface KANWelcomeViewController ()

- (void)storeHost:(NSString *)host andPort:(NSUInteger)port;
@end

@implementation KANWelcomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.hostTextField becomeFirstResponder];
}

- (IBAction)connectButtonPressed:(id)sender {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.hostTextField.text forKey:KANUserDefaultsHostKey];
    [ud setObject:@([self.portTextField.text integerValue]) forKey:KANUserDefaultsPortKey];

    self.connectabilityLabel.text = @"Connecting...";

    __block NSString *host  = self.hostTextField.text;
    __block NSUInteger port = [self.portTextField.text intValue];

    [KANAPI checkConnectabilityWithHost:host port:port authUser:nil authPass:nil completionHandler:^(KANAPIConnectability connectability) {
        switch (connectability) {
            case KANAPIConnectabilityConnectable:
                self.connectabilityLabel.text = @"Connected Successfully";
                [self storeHost:host andPort:port];
                [self performSegueWithIdentifier:@"LoginToDownloadProgress" sender:self];
                break;

            case KANAPIConnectabilityNotConnectable:
                self.connectabilityLabel.text = @"Ut oh";
                break;
            case KANAPIConnectabilityRequiresAuthentication:
                [self storeHost:host andPort:port];
                break;
        }
    }];
}

- (void)storeHost:(NSString *)host andPort:(NSUInteger)port
{
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];

    [sud setObject:host forKey:KANUserDefaultsHostKey];
    [sud setObject:@(port) forKey:KANUserDefaultsPortKey];

    [sud synchronize];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.hostTextField) {
        [self.portTextField becomeFirstResponder];
    }

    return YES;
}

@end
