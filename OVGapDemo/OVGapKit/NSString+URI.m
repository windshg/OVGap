//
//  NSString+URI.m
//  OVGap
//
//  Created by Vinson.D.Warm on 7/18/13.
//  Copyright (c) 2013 Vinson.D.Warm. All rights reserved.
//

#import "NSString+URI.h"

@implementation NSString (URI)

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
