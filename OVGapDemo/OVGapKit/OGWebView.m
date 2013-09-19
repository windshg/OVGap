//
//  OGWebView.m
//  OVGap
//
//  Created by Vinson.D.Warm on 9/3/13.
//  Copyright (c) 2013 OG. All rights reserved.
//

#import "OGWebView.h"
#import "OGInvokeCommand.h"
#import "JSONUtility.h"
#import "NSString+URI.h"

@interface OGWebView () <UIWebViewDelegate>

@end

@implementation OGWebView

@synthesize responseInBackground = _responseInBackground;
@synthesize plugins = _plugins;

- (id)init {
    self = [super init];
    if (self) {
        self.responseInBackground = NO;
        self.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.responseInBackground = NO;
        self.delegate = self;
    }
    return self;
}

- (id)initWithPlugin:(OGPlugin *)plugin {
    self = [super init];
    if (self) {
        self.responseInBackground = NO;
        plugin.webView = self;
        self.plugins = [NSMutableArray arrayWithObject:plugin];
        self.delegate = self;
    }
    return self;
}

- (id)initWithPlugins:(NSArray *)plugins {
    self = [super init];
    if (self) {
        self.responseInBackground = NO;
        self.plugins = [NSMutableArray arrayWithArray:plugins];
        for (OGPlugin *plugin in self.plugins) {
            plugin.webView = self;
        }
        self.delegate = self;
    }
    return self;
}

- (void)addPlugin:(OGPlugin *)plugin {
    if (!self.plugins) {
        self.plugins = [NSMutableArray array];
    }
    plugin.webView = self;
    [self.plugins addObject:plugin];
}

- (void)removePlugin:(OGPlugin *)plugin {
    if (!self.plugins) return;
    [self.plugins removeObject:plugin];
}

- (void)handleCommandContent:(NSString *)commandContent {
    NSInteger cmdLen = commandContent.length;
    
    NSInteger frontIdx = 0;
    for (; frontIdx < cmdLen; ++frontIdx) {
        if ([[commandContent substringWithRange:NSMakeRange(frontIdx, 1)] isEqualToString:@"/"])
            break;
    }
    
    NSInteger lastIdx = cmdLen - 1;
    for (; lastIdx >= 0; --lastIdx) {
        if ([[commandContent substringWithRange:NSMakeRange(lastIdx, 1)] isEqualToString:@"/"])
            break;
    }
    
    NSString *cmdName = [commandContent substringToIndex:frontIdx];
    NSString *cmdParams = [commandContent substringWithRange:NSMakeRange(frontIdx + 1, lastIdx - frontIdx - 1)];
    NSString *callbackId = [commandContent substringFromIndex:lastIdx + 1];
    OGInvokeCommand *invokeCommand = [[OGInvokeCommand alloc] init];
    invokeCommand.command = cmdName;
    invokeCommand.paramsInfo = [NSMutableDictionary dictionaryWithDictionary:[JSONUtility objectFromJSONString:cmdParams]];
    invokeCommand.callBackId = callbackId;
    
    if (self.plugins && self.plugins.count != 0) {
        NSString *methodName = [NSString stringWithFormat:@"%@:", cmdName];
        SEL cmdSel = NSSelectorFromString(methodName);
        BOOL methodExisted = NO;
        for (OGPlugin *plugin in self.plugins) {
            plugin.runInBackground = self.responseInBackground;
            if ([plugin respondsToSelector:cmdSel]) {
                if (plugin.runInBackground) {
                    [plugin performSelectorInBackground:cmdSel withObject:invokeCommand];
                } else {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [plugin performSelector:cmdSel withObject:invokeCommand];
                }
                methodExisted = YES;
                break;
            }
        }
        if (!methodExisted) {
            OGPlugin *plugin = [self.plugins objectAtIndex:0];
            if (plugin.runInBackground) {
                [plugin performSelectorInBackground:@selector(defaultCommand:) withObject:invokeCommand];
            } else {
                [plugin performSelector:@selector(defaultCommand:) withObject:invokeCommand];
            }
        }
    } else {
        NSLog(@"Warning: There is no plugin for this web view...");
    }
}

- (void)fetchNativeMessages {
    NSString *cmdQueueStr = [self stringByEvaluatingJavaScriptFromString:@"window.ov_gap.fetchNativeCommands()"];
    NSArray *cmdStrArr = [JSONUtility objectFromJSONString:cmdQueueStr];
    for (NSString *cmdStr in cmdStrArr) {
        [self handleCommandContent:cmdStr];
    }
}

- (void)fetchNativeGroupCommands:(NSString *)groupId {
    NSString *cmdQueueStr = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.ov_gap.fetchNativeGroupCommands(%@)", groupId]];
    NSArray *cmdStrArr = [JSONUtility objectFromJSONString:cmdQueueStr];
    for (NSString *cmdStr in cmdStrArr) {
        [self handleCommandContent:cmdStr];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString* rurl = [[request URL] absoluteString];
    rurl = [self stringByDecodingURLFormat:rurl];
    if ([rurl hasPrefix:@"ovgap://"]) {
        NSString *content = [rurl substringFromIndex:8];
        if ([content hasPrefix:@"ready"]) {
            [self fetchNativeMessages];
        } else if ([content hasPrefix:@"group"]) {
            NSString *groupId = [content substringFromIndex:6];
            [self fetchNativeGroupCommands:groupId];
        } else {
            [self handleCommandContent:content];
        }
        return NO;
    }
    
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView: shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        return [self.webViewDelegate webViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        return [self.webViewDelegate webView:self didFailLoadWithError:error];
    }
}

// to decode url string
- (NSString *)stringByDecodingURLFormat:(NSString *)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
