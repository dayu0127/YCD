//
//  GuanWangVC.m
//  JYDS
//
//  Created by liyu on 2017/7/31.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "GuanWangVC.h"
#import "BaseWKWebView.h"
@interface GuanWangVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end
@implementation GuanWangVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [YHHud showWithStatus];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) url:@"https://www.jydsapp.com"];
    [self.view addSubview:_wkWebView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
