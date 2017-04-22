//
//  BaseWKWebView.h
//  MarKet
//
//  Created by dayu on 16/5/25.
//  Copyright © 2016年 Secret. All rights reserved.
//
#import <WebKit/WebKit.h>
@interface BaseWKWebView : WKWebView<WKNavigationDelegate>
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)urlStr;
@end
