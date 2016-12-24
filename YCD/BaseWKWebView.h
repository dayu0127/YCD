//
//  BaseWKWebView.h
//  MarKet
//
//  Created by dayu on 16/5/25.
//  Copyright © 2016年 Secret. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface BaseWKWebView : WKWebView<WKNavigationDelegate>
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) UIView *opaqueView;
@end
