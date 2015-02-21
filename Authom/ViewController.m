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

@end
