//
//  BaseWKWebView.m
//  MarKet
//
//  Created by dayu on 16/5/25.
//  Copyright © 2016年 Secret. All rights reserved.
//
#import "BaseWKWebView.h"
@implementation BaseWKWebView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.navigationDelegate = self;
        self.scrollView.bounces = NO;
        _opaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _activityIndicatorView.center = _opaqueView.center;
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_opaqueView addSubview:_activityIndicatorView];
        [self addSubview:_opaqueView];
    }
    return self;
}
#pragma mark 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [_activityIndicatorView startAnimating];
    _opaqueView.hidden = NO;
}
#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_activityIndicatorView stopAnimating];
    _opaqueView.hidden = YES;
}
@end
