//
//  PhotoLibraryPlugin.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "PhotoLibraryPlugin.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotoLibraryPlugin () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) OGInvokeCommand *command;

@end

@implementation PhotoLibraryPlugin

@synthesize webViewController = _webViewController;
@synthesize command = _command;

- (void)openPhotoLibrary:(OGInvokeCommand *)command {
    self.command = command;
    
    if ([self isPhotoLibraryAvailable]){
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        if ([self canUserPickPhotosFromPhotoLibrary]){
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        }
        if ([self canUserPickVideosFromPhotoLibrary]){
            [mediaTypes addObject:(__bridge NSString *)kUTTypeMovie]; }
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        [self.webViewController presentViewController:controller
                                             animated:YES
                                           completion:^(void){
                                               NSLog(@"Picker View Controller is presented");
                                           }];
    }
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
