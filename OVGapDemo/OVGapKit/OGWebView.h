//
//  OGWebView.h
//  OVGap
//
//  Created by Vinson.D.Warm on 9/3/13.
//  Copyright (c) 2013 OG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGPlugin.h"

@class OGWebView;

@protocol OGWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(OGWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(OGWebView *)webView;
- (void)webViewDidFinishLoad:(OGWebView *)webView;
- (void)webView:(OGWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface OGWebView : UIWebView

@property (nonatomic, assign) BOOL responseInBackground;

@property (nonatomic, strong) NSMutableArray *plugins;

@property (nonatomic, weak) id<OGWebViewDelegate> webViewDelegate;

- (id)initWithPlugin:(OGPlugin *)plugin;

- (id)initWithPlugins:(NSArray *)plugins;

- (void)addPlugin:(OGPlugin *)plugin;

- (void)removePlugin:(OGPlugin *)plugin;

@end
