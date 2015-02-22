//
//  THAuthViewController.m
//  Goal: check if the user is device owner
//  Authom
//
//  Created by Mimee Xu on 2/21/15.
//  Copyright (c) 2015 Mimee Xu. All rights reserved.
//

#import "THAuthViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SVProgressHUD.h"
#import "THPaymentViewController.h"

@interface THAuthViewController ()

@property(nonatomic, strong)THPaymentViewController *paymentViewController;

@end

@implementation THAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self authWithTouchID];
    
}

- (void)authWithTouchID {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    
    //Must look like it is being evaluated
    [SVProgressHUD show];
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // Authenticate User
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              // There is error
                              if (error) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self handleError: error];
                                  });
                                  return;
                              }
                              
                              if (success) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self handleSuccess];
                                  });
                              } else {
                                  //NOT SUPPOSED TO HAPPEN??
                                  // No error but no success either??
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [SVProgressHUD dismiss];
                                  });
                              }
                          }];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID. Try to contact vendor for a different authentication."
                                                       delegate:nil
                                              cancelButtonTitle:@"Got it"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)existingPattern {
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    
    //Must look like it is being evaluated
    [SVProgressHUD show];
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                                  
                              // There is error
                              if (error) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self handleError: error];
                                  });
                                  return;
                              }
                              
                              else if (success) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self handleSuccess];
                                  });
                              } else {
                                  //NOT SUPPOSED TO HAPPEN??
                                  /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"You are not the device owner."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [SVProgressHUD dismiss];
                                  [alert show];*/
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [SVProgressHUD dismiss];
                                  });
                              }
                        }];
    } else {
        //NOT SUPPOSED TO HAPPEN??
        // \TODO: Let them authenticate in other fashion -facial i guess?
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)handleSuccess {
    [SVProgressHUD dismiss];
    
    self.paymentViewController = [[THPaymentViewController alloc] init];
    [self.navigationController pushViewController:self.paymentViewController animated:YES];
    //actually evaluates the user, show 2fa
    //before, say, photos

    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"You are the device owner!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    
    [alert show];*/
    
    return;
}
- (void)handleError:(NSError *) error {
    [SVProgressHUD dismiss];
    
    NSString *errorMsg;
    switch (error.code) {
        case LAErrorPasscodeNotSet:
            errorMsg = @"Passcode is not set :(";
            break;
        case LAErrorSystemCancel:
            errorMsg = @"Systems cancelled, please try again";
            break;
        case LAErrorTouchIDNotAvailable:
            errorMsg = @"TouchID is not available";
            break;
        case LAErrorTouchIDNotEnrolled:
            errorMsg = @"TouchID is not enrolled";
            break;
        case LAErrorUserCancel:
            errorMsg = @"You canceled authentication process";
            break;
        case LAErrorAuthenticationFailed:
            errorMsg = @"Authentication failed, please try again.";
            break;
        case LAErrorUserFallback:
            errorMsg = @"User fell back. Voided request";
            break;
        default:
            break;
    }
    //Specifies different types of error
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TouchID Error"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alert setDelegate:self];
    [alert show];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIAlertViewController
- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //\TODO: add retry option
    [self.navigationController popViewControllerAnimated:YES];
}
@end
