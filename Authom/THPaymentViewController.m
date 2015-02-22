//
//  THPaymentViewController.m
//  Authom
//
//  Created by Mimee Xu on 2/21/15.
//  Copyright (c) 2015 Mimee Xu. All rights reserved.
//

#import "THPaymentViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Braintree/Braintree.h>

@interface THPaymentViewController ()

@end

@implementation THPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNetwork {
    NSString *baseUrl = @"/token.json";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseUrl
      parameters:@{ @"server-auth": @"token", @"customer-session": @"session"}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // Setup braintree with responseObject[@"client_token"]
             // self.braintree = [Braintree braintreeWithClientToken:responseObject[@"client_token"]];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // Handle failure communicating with your server
         }];
}

@end
