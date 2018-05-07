//
//  NewSnapViewController.m
//  QuSnap
//
//  Created by Hugo Santos on 1/5/18.
//  Copyright © 2018 Hugo Santos. All rights reserved.
//

#import "NewSnapViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import Firebase;
@import FirebaseCore;

@interface NewSnapViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *snapImageView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;


@end

@implementation NewSnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapPicture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(choosePicture)];

    self.snapImageView.userInteractionEnabled = YES;
    [self.snapImageView addGestureRecognizer:tapPicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)choosePicture {
    NSLog(@"choosePicture"); //test console output
    [self chooseSnapPictureForImageView:self.snapImageView];
}


#pragma mark - image view picker code

- (void)chooseSnapPictureForImageView:(UIImageView *) imageView {
    NSLog(@"chooseSnapPictureForImageView"); //test console output
    BOOL hasPhotoLibrary = [UIImagePickerController
                            isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL hasCamera = [UIImagePickerController
                      isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (hasPhotoLibrary == NO && hasCamera == NO) {
        NSLog(@"hasPhotoLibrary == NO && hasCamera == NO"); //test console output
        return;
    }
    
    if (hasPhotoLibrary == YES || hasCamera == YES) {
        NSLog(@"hasPhotoLibrary == YES || hasCamera == YES"); //test console output
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Choose a Profile Picture"
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                           handler:nil];
        
        if (hasCamera == YES) {
            NSLog(@"hasCamera == YES"); //test console output
            UIAlertAction *useCameraAction = [UIAlertAction
                                              actionWithTitle: @"From Camera"
                                              style: UIAlertActionStyleDefault
                                              handler: ^(UIAlertAction *action) {
                                                  [self presentImagePickerUsingCamera: YES];
                                              }];
            [alertController addAction:useCameraAction];
        }
        
        UIAlertAction *usePhotosAction = [UIAlertAction
                                          actionWithTitle:@"From Photos"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              [self presentImagePickerUsingCamera: NO];
                                          }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:usePhotosAction];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        
    }
}

- (void) presentImagePickerUsingCamera:(BOOL)useCamera {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    if (useCamera == YES) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    pickerController.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissImagePicker];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.snapImageView.image = image;
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [self dismissImagePicker];
}

- (void) dismissImagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
