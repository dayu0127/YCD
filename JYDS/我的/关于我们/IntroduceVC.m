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
    [YHHud showWithStatus];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) url:IntroduceUrl];
    [self.view addSubview:_wkWebView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
