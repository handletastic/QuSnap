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

- (IBAction)submitAction:(id)sender {
    [self signinWithEmail];
}

- (void)signinWithEmail {
    [[FIRAuth auth]
     signInWithEmail:self.emailTextField.text
     password:self.passwordTextField.text
     completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
         if (error != nil) {
             NSLog(@"sucessful login!");
         } else {
             NSLog(@"error %@", error.localizedDescription);
         }
     }];
}

@end
