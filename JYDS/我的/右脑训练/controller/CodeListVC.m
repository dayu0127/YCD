//
//  CodeListVC.m
//  JYDS
//
//  Created by liyu on 2017/1/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "CodeListVC.h"
#import "BaseWKWebView.h"
@interface CodeListVC ()<WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *wkWebView;
@end

@implementation CodeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [YHHud showWithStatus];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:_wkWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kMemoryImages]];
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    [_wkWebView loadRequest:request];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [YHHud dismiss];
}
@end
