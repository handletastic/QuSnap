//
//  SplashViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 23/4/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//navigation bar show/hide
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

//splash screen buttons
- (IBAction)signupAction:(id)sender {
    NSLog(@"signup action");
}
- (IBAction)loginAction:(id)sender {
    NSLog(@"login action");
}

@end
