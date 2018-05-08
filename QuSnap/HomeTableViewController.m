//
//  HomeTableViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 1/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "HomeTableViewController.h"
@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface HomeTableViewController ()

@property (strong, nonatomic) NSMutableArray *messagesArray;

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
