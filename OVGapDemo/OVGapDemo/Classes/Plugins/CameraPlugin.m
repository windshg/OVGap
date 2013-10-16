//
//  CameraPlugin.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "CameraPlugin.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraPlugin ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) OGInvokeCommand *command;

@end

@implementation CameraPlugin

@synthesize webViewController = _webViewController;
@synthesize command = _command;

- (void)testCamera:(OGInvokeCommand *)command {
    
    self.command = command;
    
    if ([self isCameraAvailable] &&
        [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSString *requiredMediaType = (__bridge NSString *)kUTTypeImage;
        controller.mediaTypes = [[NSArray alloc] initWithObjects:requiredMediaType, nil];
        controller.allowsEditing = YES;
        controller.delegate = self;
        
        [self.webViewController presentViewController:controller
                                             animated:YES
                                           completion:^(void){
                                               NSLog(@"Picker View Controller is presented");
                             }];
    } else {
        [self toCallBackErrorWithCommand:command];
    }
}

// decide whether the camera sevice is support in this device
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera];
}

// decide whether the media support the paramMediaType
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFlashAvailableOnFrontCamera{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isFlashAvailableOnRearCamera {
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(){
        [self toCallBackSuccess:info callBackId:self.command.callBackId];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        [self toCallBackErrorWithCommand:self.command];
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
