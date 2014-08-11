//
//  patViewController.m
//  pictureAssetTest
//
//  Created by Chip Cox on 8/10/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "patViewController.h"
#import "patSecondVC.h"

@interface patViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageControl;
@property (nonatomic,strong) NSURL *imageURL;
@end

@implementation patViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPictureFromLibrary:(UIButton *)sender
{
    [self startPhotoLibraryFromViewController:self usingDelegate:self];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageURL=[info objectForKey:UIImagePickerControllerReferenceURL];
    CCLog(@"Image =%@",[info objectForKey:UIImagePickerControllerReferenceURL]);
    
    [self displayImageFromURL:self.imageURL];
}

- (void) displayImageFromURL:(NSURL*)urlIn
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    switch(status){
        case ALAuthorizationStatusDenied: {
            CCLog(@"not authorized");
            break;
        }
        case ALAuthorizationStatusRestricted: {
            CCLog(@"Restricted");
            break;
        }
        case ALAuthorizationStatusNotDetermined: {
            CCLog(@"Undetermined");
            break;
        }
        case ALAuthorizationStatusAuthorized: {
            CCLog(@"Authorized");
            CCLog(@"urlIn=%@",urlIn.pathComponents);
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            __block UIImage *returnValue = nil;
            [library assetForURL:urlIn resultBlock:^(ALAsset *asset) {
                returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageControl setImage:returnValue];
                    [self.imageControl setNeedsDisplay];
                });
            } failureBlock:^(NSError *error) {
                NSLog(@"error : %@", error);
            }];
            break;
        }
        default: {
            CCLog(@"Unknown hit default");
            break;
        }
    }
}

- (BOOL) startPhotoLibraryFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
    UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[patSecondVC class]]) {
        CCLog(@"Preparing for segue to %@",segue.destinationViewController);
        patSecondVC *dvc=segue.destinationViewController;
        dvc.transferURL=self.imageURL.absoluteString;
    } else {
        CCLog(@"Preparing to segue to unknown destination view controller %@",segue.destinationViewController);
    }
}

@end
