//
//  OGDemoWebViewController.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 13-9-13.
//  Copyright (c) 2013年 vepace. All rights reserved.
//

#import "OGDemoWebViewController.h"
#import "OGWebView.h"
// import plugin classes
#import "InfoPlugin.h"
#import "PhotoLibraryPlugin.h"
#import "CameraPlugin.h"
#import "SenserPlugin.h"
#import "NetworkPlugin.h"
#import "AudioPlugin.h"
#import "DispatchPlugin.h"
#import "AddressBookPlugin.h"

#define DEMO_WEBVIEW_URL @"http://1.ovgapdemo.duapp.com/demo.html"

@interface OGDemoWebViewController () <OGWebViewDelegate>

@property (nonatomic, strong) OGWebView *webView;

@end

@implementation OGDemoWebViewController

@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.webView = [[OGWebView alloc] initWithFrame:self.view.bounds];
    // add plugin
    InfoPlugin *infoPlugin = [[InfoPlugin alloc] init];
    [self.webView addPlugin:infoPlugin];
    // add plugin
    AudioPlugin *audioPlugin = [[AudioPlugin alloc] init];
    [self.webView addPlugin:audioPlugin];
    // add plugin
    PhotoLibraryPlugin *photoLibraryPlugin = [[PhotoLibraryPlugin alloc] init];
    photoLibraryPlugin.webViewController = self;
    [self.webView addPlugin:photoLibraryPlugin];
    // add plugin
    CameraPlugin *cameraPlugin = [[CameraPlugin alloc] init];
    cameraPlugin.webViewController = self;
    [self.webView addPlugin:cameraPlugin];
    // add plugin
    SenserPlugin *senserPlugin = [[SenserPlugin alloc] init];
    [self.webView addPlugin:senserPlugin];
    // add plugin
    NetworkPlugin *networkPlugin = [[NetworkPlugin alloc] init];
    [self.webView addPlugin:networkPlugin];
    // add plugin
    DispatchPlugin *dispatchPlugin = [[DispatchPlugin alloc] init];
    [self.webView addPlugin:dispatchPlugin];
    // add plugin
    AddressBookPlugin *addressBookPlugin = [[AddressBookPlugin alloc] init];
    [self.webView addPlugin:addressBookPlugin];
    
    self.webView.webViewDelegate = self;
    [self.view addSubview:self.webView];
    
    // load from remote server
    [self loadFromRemoteServer];
}

- (void)loadFromRemoteServer {
    NSURL *url = [NSURL URLWithString:DEMO_WEBVIEW_URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - OGWebViewDelegate
- (BOOL)webView:(OGWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(OGWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(OGWebView *)webView {
    
}

- (void)webView:(OGWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
