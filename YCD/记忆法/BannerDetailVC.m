//
//  BannerDetailVC.m
//  YCD
//
//  Created by liyu on 2016/12/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BannerDetailVC.h"
#import "BaseWKWebView.h"
@interface BannerDetailVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation BannerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _bannerTitle;
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkUrl]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}
@end
