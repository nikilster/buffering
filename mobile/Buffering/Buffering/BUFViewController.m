//
//  BUFViewController.m
//  Buffering
//
//  Created by Nikil Viswanathan on 5/8/14.
//  Copyright (c) 2014 Nikil Viswanathan. All rights reserved.
//

#import "BUFViewController.h"
#import <AFNetworking/AFNetworking.h>

#define SERVER_URL @"http://192.168.1.55:8080"

@interface BUFViewController ()

@end

@implementation BUFViewController

- (IBAction)pushupButtonClicked:(id)sender {
    
    NSLog(@"button clicked");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    
    [manager GET:SERVER_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
