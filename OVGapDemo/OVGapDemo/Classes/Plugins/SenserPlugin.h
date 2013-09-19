//
//  SenserPlugin.h
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "OGPlugin.h"

@interface SenserPlugin : OGPlugin

- (void)openGesture:(OGInvokeCommand *)command;

- (void)openAccelerator:(OGInvokeCommand *)command;

@end
