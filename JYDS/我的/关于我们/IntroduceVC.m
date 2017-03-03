//
//  IntroduceVC.m
//  JYDS
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "IntroduceVC.h"
#import "BaseWKWebView.h"
@interface IntroduceVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end
@implementation IntroduceVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:IntroduceUrl]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}
@end
