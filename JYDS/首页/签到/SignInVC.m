//
//  SignInVC.m
//  JYDS
//
//  Created by liyu on 2017/4/17.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SignInVC.h"
#import "BaseWKWebView.h"
@interface SignInVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = kSignIn([YHSingleton shareSingleton].userInfo.phoneNum);
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
