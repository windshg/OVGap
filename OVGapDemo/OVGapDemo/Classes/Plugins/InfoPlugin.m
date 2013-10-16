//
//  InfoPlugin.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "InfoPlugin.h"

@interface InfoPlugin () 

@end

@implementation InfoPlugin


- (void)testDeviceInfo:(OGInvokeCommand *)command {
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo setObject:[[UIDevice currentDevice] name] forKey:@"name"];
    [deviceInfo setObject:[[UIDevice currentDevice] systemName] forKey:@"systemName"];
    [deviceInfo setObject:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    [deviceInfo setObject:[[UIDevice currentDevice] model] forKey:@"model"];
    [deviceInfo setObject:[[UIDevice currentDevice] localizedModel] forKey:@"localizedModel"];
    [self toCallBackSuccess:deviceInfo callBackId:command.callBackId];
}


@end
