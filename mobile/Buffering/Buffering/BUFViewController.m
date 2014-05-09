//
//  BUFViewController.m
//  Buffering
//
//  Created by Nikil Viswanathan on 5/8/14.
//  Copyright (c) 2014 Nikil Viswanathan. All rights reserved.
//

#import "BUFViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface BUFViewController ()

@end

@implementation BUFViewController

- (IBAction)pushupButtonClicked:(id)sender {
    
    NSLog(@"button clicked");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    
    [manager POST:@"http://www.google.com/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
