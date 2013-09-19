//
//  OGInvokeCommand.h
//  OVGap
//
//  Created by Vinson.D.Warm on 9/3/13.
//  Copyright (c) 2013 OG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGInvokeCommand : NSObject

@property (nonatomic, strong) NSString *command;
@property (nonatomic, strong) NSMutableDictionary *paramsInfo;
@property (nonatomic, strong) NSString *callBackId;

@end
