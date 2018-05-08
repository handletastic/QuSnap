//
//  HomeTableViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 1/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "HomeTableViewController.h"
#import "SnapViewController.h"
@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface HomeTableViewController ()

@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) NSMutableArray *keysArray;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMessages];
}

- (void)getMessages {
    NSString *userID = [FIRAuth auth].currentUser.uid; //grab userid
    
    FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
    FIRDatabaseQuery *messagesQuery = [[databaseRef child:@"messages"] child:userID]; //ref to get messages with uid ref
    FIRDatabaseReference *ref = messagesQuery.ref;
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *queryResult = snapshot.value;
        
        self.messagesArray = [[NSMutableArray alloc] init];
        self.messagesArray = [[queryResult allValues] mutableCopy];
        
        self.keysArray =[[queryResult allKeys] mutableCopy];
        
        [self.tableView reloadData]; //reload the data on the table view after fetching the messages array of the user
        
        //debug for messages for the currently logged user
        NSDictionary *dict = snapshot.value;
        NSString *key = snapshot.key;
        NSLog(@"get messages dictionary %@ key %@" , dict, key);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.messagesArray == nil || self.messagesArray.count == 0) { //there are no messages to display to the user
        return 1; //still return a single row cell
    }
    
    return self.messagesArray.count; //return the number of messages on the array to create the right number of cell rows
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (self.messagesArray == nil || self.messagesArray.count == 0) { //check if there is an array recipient
     return; //there are no recipients, hence do nothing
 }
 
     [self performSegueWithIdentifier:@"pushToViewMessage" sender:self]; //call the seg method
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"messageCell"]; //subtitle cell style allows to display the senderUsername on the message cell
    
    //loading messages
    if (self.messagesArray == nil) { //if it is nil, therefore it is loading
        cell.textLabel.text = @"Loading...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    // no messages to display to user
    if (self.messagesArray == 0) { //there are no recipients
        cell.textLabel.text = @"There are no snaps... yet!";
        cell.textLabel.textAlignment = NSTextAlignmentCenter; //formatting
        cell.accessoryType = UITableViewCellAccessoryNone; //formatting
        
        return cell;
    }
    
    //gets the matching recipient object for the matching cell
    NSDictionary *messageInfo = [self.messagesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [messageInfo objectForKey:@"messageText"]; //gets the username and injects it on the cell
    cell.detailTextLabel.text = [messageInfo objectForKey:@"senderUsername"];
    cell.textLabel.textAlignment = NSTextAlignmentLeft; //formatting
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //just to make it a bit more intuitive
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToViewMessage"] == YES) {
        SnapViewController *viewSnapController = (SnapViewController *)segue.destinationViewController;
        
        viewSnapController.messageInfo = [self.messagesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

@end
