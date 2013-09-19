//
//  OGPlugin.m
//  OVGap
//
//  Created by Vinson.D.Warm on 9/3/13.
//  Copyright (c) 2013 OG. All rights reserved.
//

#import "OGPlugin.h"
#import "JSONUtility.h"

@implementation OGPlugin

@synthesize runInBackground = _runInBackground;
@synthesize webView = _webView;

- (void)defaultCommand:(OGInvokeCommand *)command {
    [self toCallBackErrorWithCommand:command];
}

- (void)toCallBackSuccess:(NSDictionary *)resultInfo callBackId:(NSString *)callBackId {
    if (resultInfo == nil) {
        resultInfo = [NSDictionary dictionary];
    }
    if (callBackId == nil || [callBackId isEqualToString:@""]) {
        callBackId = @"0";
    }
    NSString *callbackStr = [NSString stringWithFormat:@"window.ov_gap.callbackSuccess(%@, %@)", callBackId, [JSONUtility stringFromJSONObject:resultInfo]];
    [self performSelectorOnMainThread:@selector(evalJS:) withObject:callbackStr waitUntilDone:NO];

}

- (void)toCallBackError:(NSDictionary *)errorInfo callBackId:(NSString *)callBackId {
    if (errorInfo == nil) {
        errorInfo = [NSDictionary dictionary];
    }
    if (callBackId == nil || [callBackId isEqualToString:@""]) {
        callBackId = @"0";
    }
    NSString *callbackStr = [NSString stringWithFormat:@"window.ov_gap.callbackError(%@, %@)", callBackId, [JSONUtility stringFromJSONObject:errorInfo]];
    [self performSelectorOnMainThread:@selector(evalJS:) withObject:callbackStr waitUntilDone:NO];
}

- (void)toTriggerListenerSuccess:(NSDictionary *)params listenId:(NSString *)listenId {
    if (params == nil) {
        params = [NSDictionary dictionary];
    }
    if (listenId == nil || [listenId isEqualToString:@""]) {
        listenId = @"0";
    }
    NSString *triggerStr = [NSString stringWithFormat:@"window.ov_gap.triggerListenerSuccess(%@, %@)", listenId, [JSONUtility stringFromJSONObject:params]];
    [self performSelectorOnMainThread:@selector(evalJS:) withObject:triggerStr waitUntilDone:NO];
}

- (void)toTriggerListenerError:(NSDictionary *)params listenId:(NSString *)listenId {
    if (params == nil) {
        params = [NSDictionary dictionary];
    }
    if (listenId == nil || [listenId isEqualToString:@""]) {
        listenId = @"0";
    }
    NSString *triggerStr = [NSString stringWithFormat:@"window.ov_gap.triggerListenerFail(%@, %@)", listenId, [JSONUtility stringFromJSONObject:params]];
    [self performSelectorOnMainThread:@selector(evalJS:) withObject:triggerStr waitUntilDone:NO];
}

- (void)toCallBackSuccessWithCommand:(OGInvokeCommand *)command {
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [resultDic setValue:@"0" forKey:@"errno"];
    [resultDic setValue:@"Callback Success..." forKey:@"errmsg"];
    [self toCallBackSuccess:resultDic callBackId:command.callBackId];
}

- (void)toCallBackErrorWithCommand:(OGInvokeCommand *)command {
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [resultDic setValue:@"-1" forKey:@"errno"];
    NSString *errMsg = [NSString stringWithFormat:@"%@ : No such method in native code...", command.command];
    [resultDic setValue:errMsg forKey:@"errmsg"];
    [self toCallBackError:resultDic callBackId:command.callBackId];
}

- (void)evalJS:(NSString *)callbackStr {
    if (self.webView) {
        [self.webView stringByEvaluatingJavaScriptFromString:callbackStr];
    }
}

@end
