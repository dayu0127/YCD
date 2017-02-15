//
//  BannerDetailVC.m
//  JYDS
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
    self.leftBarButton.hidden = NO;
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkUrl]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}
@end
