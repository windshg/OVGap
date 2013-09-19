//
//  OGPlugin.h
//  OVGap
//
//  Created by Vinson.D.Warm on 9/3/13.
//  Copyright (c) 2013 OG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGInvokeCommand.h"

@interface OGPlugin : NSObject

@property (nonatomic, assign) BOOL runInBackground;
@property (nonatomic, weak) UIWebView *webView;

- (void)defaultCommand:(OGInvokeCommand *)command;

- (void)toCallBackSuccess:(NSDictionary *)result callBackId:(NSString *)callBackId;

- (void)toCallBackError:(NSDictionary *)result callBackId:(NSString *)callBackId;

- (void)toTriggerListenerSuccess:(NSDictionary *)params listenId:(NSString *)listenId;

- (void)toTriggerListenerError:(NSDictionary *)params listenId:(NSString *)listenId;

- (void)toCallBackSuccessWithCommand:(OGInvokeCommand *)command;

- (void)toCallBackErrorWithCommand:(OGInvokeCommand *)command;

@end
