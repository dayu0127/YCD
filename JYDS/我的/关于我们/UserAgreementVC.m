//
//  UserAgreementVC.m
//  JYDS
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "UserAgreementVC.h"
#import "BaseWKWebView.h"
@interface UserAgreementVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end
@implementation UserAgreementVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:UserAgreementUrl]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}
@end
