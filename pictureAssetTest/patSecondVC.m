//
//  patSecondVC.m
//  pictureAssetTest
//
//  Created by Chip Cox on 8/10/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "patSecondVC.h"

@interface patSecondVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageControl;

@end

@implementation patSecondVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CCLog(@"photo url=%@",self.transferURL);
    [self displayImageFromURL:[NSURL fileURLWithPath:self.transferURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                    CCLog(@"self.imageControl=%@",self.imageControl.description);
                    [self.imageControl setImage:[UIImage imageNamed:@"bayerlogo"]];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
