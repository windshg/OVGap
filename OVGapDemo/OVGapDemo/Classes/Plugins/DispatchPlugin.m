//
//  DispatchPlugin.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "DispatchPlugin.h"

@implementation DispatchPlugin

- (void)testDispatch:(OGInvokeCommand *)command {
    // TO DO
    [self toCallBackSuccess:command.paramsInfo callBackId:command.callBackId];
}

- (void)testGroupDispatch:(OGInvokeCommand *)command {
    // TO DO
    [self toCallBackSuccess:command.paramsInfo callBackId:command.callBackId];
}

@end
