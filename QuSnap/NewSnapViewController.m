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
@import FirebaseStorage;

@interface NewSnapViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *snapImageView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation NewSnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create a tap gesture for when the user wants to add a photo to his snap
    UITapGestureRecognizer *tapPicture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(choosePicture)];

    self.snapImageView.userInteractionEnabled = YES;
    [self.snapImageView addGestureRecognizer:tapPicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendAction:(id)sender {
    NSLog(@"sendAction");
    [self saveMessageToFirebase];
}

- (void)saveMessageToFirebase {
    NSLog(@"saveMessageToDatabase");
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
    
    NSString *key = [[databaseRef child: @"messages"] childByAutoId].key; //creating a path to save to
    
    [self uploadImageToFirebase:key];
    
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    [message setValue:currentUser.uid forKey:@"sender"];
    [message setValue:currentUser.displayName forKey:@"senderUsername"]; //what we should display on message cell
    [message setValue:self.recipientInfo[@"uid"] forKey:@"recipient"];
    [message setValue:self.recipientInfo[@"username"] forKey:@"recipientUsername"];
    [message setValue:self.messageTextField.text forKey:@"messageText"];
    
    NSString *messagePathString = [NSString stringWithFormat:@"/messages/%@/", self.recipientInfo[@"uid"]];
    
    NSDictionary *childUpdates = @{[messagePathString stringByAppendingString:key]: message}; //we specify the path and value defined above
    
    [databaseRef updateChildValues:childUpdates];
}

- (void)uploadImageToFirebase:(NSString *)key { //we pass the key of the message as an arg to be able to crossinfo
    //create a root reference
    NSLog(@"uploadImageToFirebase"); //test console output
    
    FIRStorageReference *storageRef = [[FIRStorage storage] reference];
    NSString *imagesPath = [NSString stringWithFormat:@"/images/%@", key]; //defining the storage path for img
    FIRStorageReference *imagesRef = [storageRef child:imagesPath];
    NSData *imageData = UIImageJPEGRepresentation(self.snapImageView.image, 0.5); //added compression for filesize
    
    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
    metadata.contentType = @"image/jpeg"; //setting the data format for servers to know how to handle
    
    [imagesRef putData:imageData metadata:metadata
            completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error %@", error);
            //TODO:show error message and let them retry
            return;
        }
        
        NSLog(@"success! uploaded metadata %@", metadata); //test console output
    }];
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
