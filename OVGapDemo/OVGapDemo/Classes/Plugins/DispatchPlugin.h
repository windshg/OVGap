//
//  DispatchPlugin.h
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "OGPlugin.h"

@interface DispatchPlugin : OGPlugin

- (void)testDispatch:(OGInvokeCommand *)command;

- (void)testGroupDispatch:(OGInvokeCommand *)command;

@end
