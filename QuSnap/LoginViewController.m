//
//  LoginViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 27/4/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "LoginViewController.h"
@import FirebaseAuth;

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/*
- (IBAction)submitAction:(id)sender {
    [self signinWithEmail:<#(NSString *)#> password:<#(NSString *)#>]
}*/

- (void)signinWithEmail:(NSString *)email
               password:(NSString *)password {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 if (error != nil) {
                                     NSLog(@"sucessful login!");
                                 } else {
                                     NSLog(@"error %@", error.localizedDescription);
                                 }
                             }];
}

@end
