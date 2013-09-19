//
//  JSONUtility.m
//  OVGap
//
//  Created by Vinson.D.Warm on 9/3/13.
//  Copyright (c) 2013 OG. All rights reserved.
//

#import "JSONUtility.h"

@implementation JSONUtility

+ (id)objectFromJSONString:(NSString *)jsonStr {
    if (![jsonStr isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSError *jsonParsingError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[JSONUtility dataFromJSONString:jsonStr] options:0 error:&jsonParsingError];
    return object;
}

+ (NSString *)stringFromJSONObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    NSError *jsonParsingError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&jsonParsingError];
    return [JSONUtility stringFromJSONData:data];
}

+ (id)objectFromJSONData:(NSData *)jsonData {
    if (![jsonData isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    NSError *jsonParsingError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParsingError];
    return object;
}

+ (NSData *)dataFromJSONObject:(id)object {
    if ([object isKindOfClass:[NSData class]]) {
        return object;
    }
    
    NSError *jsonParsingError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&jsonParsingError];
    return data;
}

+ (NSData *)dataFromJSONString:(NSString *)jsonStr {
    if (![jsonStr isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)stringFromJSONData:(NSData *)jsonData {
    if (![jsonData isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
