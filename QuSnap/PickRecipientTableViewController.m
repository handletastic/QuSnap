//
//  PickRecipientTableViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 2/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "PickRecipientTableViewController.h"
#import "NewSnapViewController.h"
@import FirebaseDatabase;
@import Firebase;

@interface PickRecipientTableViewController ()

@property (strong, nonatomic) NSMutableArray *recipientsArray;

@end

@implementation PickRecipientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getRecipients];
}

- (void)getRecipients {
    FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersRef = [databaseRef child:@"users"];
    
    [usersRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //initiate the array of recipients
        self.recipientsArray = [[NSMutableArray alloc] init];
        //populate the array of recipients
        self.recipientsArray = [[snapshot.value allValues] mutableCopy];
        
        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { //upon selecting a row
    if (self.recipientsArray == nil || self.recipientsArray.count == 0) { //check if there is an array recipient
        return; //there are no recipients, hence do nothing
    }
    
    [self performSegueWithIdentifier:@"pushToSnapViewController" sender:self]; //call the seg method
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //because the data to be displayed is all of the same type/format
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recipientsArray == nil || self.recipientsArray.count == 0) { //check if there is an array recipient
         return 1; //this will be a loading row
    }
    return self.recipientsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipientRI" forIndexPath:indexPath];
    
    if (self.recipientsArray == nil) { //if it is nil, therefore it is loading
        cell.textLabel.text = @"Loading...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    if (self.recipientsArray == 0) { //there are no recipients
        cell.textLabel.text = @"There is nobody to snap to";
        cell.textLabel.textAlignment = NSTextAlignmentCenter; //formatting
        cell.accessoryType = UITableViewCellAccessoryNone; //formatting
        
        return cell;
    }
    
    //gets the matching recipient object for the matching cell
    NSDictionary *userInfo = [self.recipientsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [userInfo objectForKey:@"username"]; //gets the username and injects it on the cell
    cell.textLabel.textAlignment = NSTextAlignmentLeft; //formatting
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //just to make it a bit more intuitive
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //prep for seg
    if ([segue.identifier isEqualToString:@"pushToSnapViewController"] == YES) {
        NewSnapViewController *snapViewController = (NewSnapViewController *)segue.destinationViewController;
        
        snapViewController.recipientInfo = [self.recipientsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

@end
