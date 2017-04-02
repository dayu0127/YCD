//
//  InviteRewardsVC.m
//  JYDS
//
//  Created by 大雨 on 2017/4/2.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "InviteRewardsVC.h"
#import "BaseWKWebView.h"
@interface InviteRewardsVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation InviteRewardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kInviteRewards]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
