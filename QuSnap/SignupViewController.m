//
//  SignupViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 24/4/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "SignupViewController.h"
@import FirebaseAuth;
@import FirebaseDatabase;

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

//validation methods
    //email validation method
- (BOOL) validEmailAddress:(NSString *) emailString {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailValidation evaluateWithObject:emailString];
}
    //password validation method
- (BOOL) validPassword:(NSString *) passwordString {
    NSString *passwordRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,20}$";
    NSPredicate *passwordValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordValidation evaluateWithObject:passwordString];
}

//submit signup form
- (IBAction)submitAction:(id)sender {

    //textfield validation
    if ([_emailTextField hasText] &&
        [_usernameTextField hasText] &&
        [_passwordTextField hasText]) { //if all fields are filled

        //email validation
        if (![self validEmailAddress:self.emailTextField.text]) { //if email is invalid
            [self invalidEmailAddressAlert];
            return;
        }
        //password validation
        if (![self validPassword:self.passwordTextField.text]) { //if password is invalid
            [self invalidPasswordAlert];
        } else { //if password is valid
            //create user
            [self signupUserWithEmail];
        }
        
    } else { //there are empty fields
        [self emptyFieldsAlert];
    }
}

- (void)signupUserWithEmail {
    //start a loading indicator
    [[FIRAuth auth]
     createUserWithEmail:self.emailTextField.text
     password:self.passwordTextField.text
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         if (error == nil) {
             FIRUser *currentUser = [FIRAuth auth].currentUser;
             FIRUserProfileChangeRequest *changeRequest = [currentUser profileChangeRequest];
             changeRequest.displayName = self.usernameTextField.text;
             [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                 if (error) { //an error happened
                     NSLog(@"error %@", error.localizedDescription);
                 } else {
                     //profile update
                 }
             }];
             //add user to a new datastore
             FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
             FIRDatabaseReference *usersRef = [[databaseRef child:@"users"] child:currentUser.uid];
             
             NSDictionary *userInfo = @{@"uid": currentUser.uid, @"username": self.usernameTextField.text};
             
             [usersRef setValue:userInfo];
             
         } else {
             //show error
         }
         //upon completion since it is asynchronous
         NSLog(@"user %@ error %@", user, error);
         //finish a loading indicator
     }];
}


//validation alerts
    //email validation alert
- (void) invalidEmailAddressAlert {
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
    //password validation alert
- (void) invalidPasswordAlert {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Oops!"
                                          message:@"Please make sure your password contains an uppercase letter, a lowercase letter, a number and is 8 characters long."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmationAction = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:nil];
    [alertController addAction:confirmationAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
    //empty fields validation alert
- (void) emptyFieldsAlert {
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

@end
