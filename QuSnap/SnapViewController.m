//
//  SnapViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 8/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "SnapViewController.h"
@import Firebase;

@interface SnapViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTextLabel;

@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInterface];
    NSLog(@"message info %@", self.messageInfo);
}

- (void)setupInterface {
    self.messageTextLabel.text = [self.messageInfo objectForKey:@"messageText"]; //this sets the message
    self.fromLabel.text = [NSString stringWithFormat:@"From: %@", [self.messageInfo objectForKey:@"senderUsername"]]; //this sets the sender name on the from label on the snapview controller
    
    [self getImageFromFirebase];
}

- (void)getImageFromFirebase {
    FIRStorageReference *storageRef = [[FIRStorage storage] reference];
    NSString *imagesPath = [NSString stringWithFormat:@"/images/%@", self.messageKey]; //defining the storage path for img
    FIRStorageReference *imagesRef = [storageRef child:imagesPath];
    
    // Download in memory with a maximum allowed size of 5MB (1 * 1024 * 1024 bytes)
    [imagesRef  dataWithMaxSize:5 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
        if (error != nil) {
            NSLog(@"error downloading image %@", error.localizedDescription);
        } else {
            // Data for "images/island.jpg" is returned
            self.messageImageView.image = [UIImage imageWithData:data];
        }
    }];
}

@end
