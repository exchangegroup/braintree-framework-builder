//
//  ViewController.m
//  BraintreeFrameworkBuilder
//
//  Created by Evgenii Neumerzhitckii on 31/03/2015.
//  Copyright (c) 2015 The Exchange Group Pty Ltd. All rights reserved.
//

#import "ViewController.h"
#import <Braintree/Braintree.h>

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[Braintree alloc] init];
}

@end
