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
    NSDictionary *resultInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:@"currentState"];
    [self toTriggerListenerSuccess:resultInfo listenId:@"1001"];
}

- (void)visitUserDefault:(OGInvokeCommand *)command {
    
}

- (void)readAddressBook:(OGInvokeCommand *)command {
    
}


@end
