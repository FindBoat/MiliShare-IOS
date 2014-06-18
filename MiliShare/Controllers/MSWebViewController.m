//
//  MSWebViewController.m
//  MiliShare
//
//  Created by Hang Zhao on 6/9/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "MSWebViewController.h"

@interface MSWebViewController ()

@end

@implementation MSWebViewController

- (void)loadView {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    if (_url) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_url];
        [(UIWebView *)self.view loadRequest:req];
    }
}

@end
