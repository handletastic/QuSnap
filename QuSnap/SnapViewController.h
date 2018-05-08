//
//  SnapViewController.h
//  QuSnap
//
//  Created by Hugo Santos on 8/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnapViewController : UIViewController

@property (strong, nonatomic) NSDictionary *messageInfo;
@property (strong, nonatomic) NSString *messageKey; //setup to pass the messageKey to fetch the actual message details and image storage

@end
