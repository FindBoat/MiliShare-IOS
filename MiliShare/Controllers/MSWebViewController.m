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
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"MilliSync";
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
    
    // Swipe to back.
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    if (_url) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_url];
        [(UIWebView *)self.view loadRequest:req];
    }
}

#pragma mark - Swipe action.
- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
