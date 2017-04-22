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
    [YHHud showWithStatus];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) url:UserAgreementUrl];
    [self.view addSubview:_wkWebView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
