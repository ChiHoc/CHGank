//
//  GKWebViewController.m
//  Quketi
//
//  Created by ChiHo on 14/10/29.
//  Copyright (c) 2014年 YouthMBA. All rights reserved.
//

#import "GKWebViewController.h"

@interface GKWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *URL;

@end

@implementation GKWebViewController

- (id)initWithRequestString:(NSString *)string
{
    self = [super init];
    if (self) {
        self.URL = [NSURL URLWithString:string];
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                     target:self
                                                                                     action:@selector(onCancelBtnDidPressed:)];
        [self.navigationItem setLeftBarButtonItem:closeButton];
    }
    return self;
}

- (id)initWithRequestURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.URL = URL;
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                     target:self
                                                                                     action:@selector(onCancelBtnDidPressed:)];
        [self.navigationItem setLeftBarButtonItem:closeButton];
    }
    return self;
}

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView setDelegate:self];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.webView setOpaque:YES];
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.URL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:10];
    if (self.userAgent) {
        [urlRequest setValue:self.userAgent forHTTPHeaderField:@"user-agent"];
    }
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:LS(@"正在加载")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    [self setNavigationBarTitle:title];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

@end
