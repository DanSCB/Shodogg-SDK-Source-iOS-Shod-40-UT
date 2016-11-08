//
//  SHMIDAuthViewController.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 10/30/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import "SHMIDAuthViewController.h"

@interface SHMIDAuthViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSURL *authorizationURL;
@property (nonatomic, copy) SHAuthControllerDoneBlock doneBlock;
@property (assign) SHAuthProvider provider;
@end

@implementation SHMIDAuthViewController

- (instancetype)initWithAuthProvider:(SHAuthProvider)provider
                authorizationURL:(NSURL *)url
                 completionBlock:(SHAuthControllerDoneBlock)block {
    
    self = [super init];
    
    if (self) {
     
        _doneBlock  = block;
        _provider   = provider;
        _authorizationURL = url;
        
        //NavigationBar properties
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        
        //NavigtaionItem[Cancel]
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                            target:self
                                            action:@selector(didTapCancel:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        
        //NavigtaionItem[Indicator]
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.hidesWhenStopped = YES;
        UIBarButtonItem *indicator = [[UIBarButtonItem alloc]
                                      initWithCustomView:_activityIndicator];
        [_activityIndicator startAnimating];
        self.navigationItem.rightBarButtonItem = indicator;
        
        //Add WebView
        _webView = [[UIWebView alloc] init];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.delegate = self;
        [self.view addSubview:_webView];
        

        //Constraints
        NSDictionary *views = @{@"WebView" : _webView};
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|[WebView]|"
                                   options:0 metrics:0 views:views]];
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|[WebView]|"
                                   options:0 metrics:0 views:views]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.authorizationURL];
    [self.webView loadRequest:request];
}

- (void)didTapCancel:(id)sender {
    [self finished];
}

- (void)finished {
    if (_doneBlock) {
        _doneBlock();
        _doneBlock = nil;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                                 navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSURL *requestURL = webView.request.URL;
    if ([_authorizationURL isEqual:requestURL]
        || [requestURL.host isEqualToString:@"login.salesforce.com"]
        || [requestURL.host isEqualToString:@"accounts.google.com"]) {
        [_activityIndicator stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s - Message: %@ ", __PRETTY_FUNCTION__, [error getFailureMessageInResponseData]);
}

#pragma mark - OAuthDelegate

- (void)didReceiveAuthenticationCode {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_doneBlock) _doneBlock = nil;
}

@end