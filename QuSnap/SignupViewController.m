//
//  SignupViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 24/4/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//email validation method
-(BOOL) validEmailAddress:(NSString*) emailString {
    NSString *emailRegex =   @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailValidation evaluateWithObject:emailString]) {
        return FALSE;
    }
    return TRUE;
}

- (IBAction)submitAction:(id)sender {
    NSDictionary *signupParams = [[NSDictionary alloc] init];
    
    //textfield validation
    if (self.emailTextField.text > 0 &&
        self.usernameTextField.text > 0 &&
        self.passwordTextField.text > 0) { //if all fields are filled
        signupParams = @{@"email" : self.emailTextField.text,
                         @"username" : self.usernameTextField.text,
                         @"password" : self.passwordTextField.text};
        
        //email validation
        if (![self validEmailAddress:self.emailTextField.text]) { //if email is invalid
            //alert controller
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Oops!"
                                                  message:@"Please make sure that the email is correct"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmationAction = [UIAlertAction
                                                 actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                                 handler:nil];
            [alertController addAction:confirmationAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        NSLog(@"signup params %@", signupParams);
        
        //firebase
    } else { //there are empty fields
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Oops"
                                              message:@"Please make sure you fill out all the fields"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmationAction = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:nil];
        
        [alertController addAction:confirmationAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

@end
