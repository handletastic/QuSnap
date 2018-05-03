//
//  VerifySessionViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 30/4/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "VerifySessionViewController.h"
#import "HomeTableViewController.h"
@import FirebaseAuth;

@interface VerifySessionViewController ()

@end

@implementation VerifySessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get access to the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ //this is to make that if we have a user we login, else we signup
        [[FIRAuth auth]
         addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                         FIRUser *_Nullable user) {
             if ([FIRAuth auth].currentUser) { //user signed in
                 //setup
                 HomeTableViewController *homeTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeTableViewControllerSID"];
                 [self.navigationController setViewControllers:@[homeTableViewController] animated:YES];
                 
                 NSLog(@"send to home view controller, not yet set");
             } else { //user not signed in
                 [self performSegueWithIdentifier:@"pushToSplashViewSegue" sender:self];
             }
         }];
    });
}

@end
