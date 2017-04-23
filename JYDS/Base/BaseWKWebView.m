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
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)urlStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.navigationDelegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [self loadRequest:request];
    }
    return self;
}
#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [YHHud dismiss];
}
@end
