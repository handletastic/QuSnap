//
//  SnapViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 8/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "SnapViewController.h"

@interface SnapViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTextLabel;

@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"message info %@", self.messageInfo);
}

@end
