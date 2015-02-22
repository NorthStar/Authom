//
//  ViewController.m
//  Authom
//
//  Created by Mimee Xu on 2/21/15.
//  Copyright (c) 2015 Mimee Xu. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetKeychain];
    
    [self.navigationController setTitle:@"Authom"];
    
    CGRect bounds = [self.view bounds];
    CGRect buttonFrame = CGRectMake(0, bounds.size.height*2/3, bounds.size.width, 40);
    
    //My own auth button
    self.authButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.authButton setBackgroundColor:[UIColor blackColor]];

    [self.authButton.titleLabel setTextColor:[UIColor grayColor]];
    [self.authButton.titleLabel setText: @"AuthButton"];
    [self.authButton setTitle:@"AuthButton" forState:UIControlStateNormal];
    
    [self.authButton addTarget:self action:@selector(onAuthButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Digits' auth button
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        // play with Digits session
        if (session) {
            NSLog(@"Well there is a session");
        }
        if (error) {
            NSLog(@"There is an error");
        }
    }];
    // Start the authentication flow with the custom appearance. Nil parameters for default values.
    Digits *digits = [Digits sharedInstance];
    
    //STYLE
    // Create an already initialized DGTAppearance object with standard colors:
    DGTAppearance *digitsAppearance =
    [[DGTAppearance alloc] init];
    // "Cool" look
    digitsAppearance.backgroundColor = [UIColor
                                        colorWithRed:81/255.
                                        green:208/255.
                                        blue:90/255.
                                        alpha:1];
    digitsAppearance.accentColor = [UIColor redColor];
    
    [digits authenticateWithDigitsAppearance:digitsAppearance
                              viewController:nil
                                       title:nil
                                  completion:^(DGTSession *session,
                                               NSError *error) {
                                      // Inspect session/error objects
                                  }];
    authenticateButton.center = self.view.center;
    
    
    [self.view addSubview:authenticateButton];

    [self.view addSubview:self.authButton];
    
}


- (void)onAuthButtonPress {
    self.authController = [[THAuthViewController alloc] init];
    
    [self.navigationController pushViewController:self.authController animated:YES];
    
    NSLog(@"exiting");
    
}

- (void)didTapButton {
    [[Digits sharedInstance] authenticateWithCompletion:^
     (DGTSession* session, NSError *error) {
         if (session) {
             // Inspect session/error objects
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -debug mode
-(void)resetKeychain {
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
}

-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) dict);
    NSAssert(result == noErr || result == errSecItemNotFound, @"Error deleting keychain data (%d)", (int)result);
}

@end
