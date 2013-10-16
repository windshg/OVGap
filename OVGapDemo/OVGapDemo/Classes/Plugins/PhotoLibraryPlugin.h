//
//  PhotoLibraryPlugin.h
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "OGPlugin.h"
#import "OGDemoWebViewController.h"

@interface PhotoLibraryPlugin : OGPlugin

@property (nonatomic, assign) OGDemoWebViewController *webViewController;

- (void)openPhotoLibrary:(OGInvokeCommand *)command;

@end
