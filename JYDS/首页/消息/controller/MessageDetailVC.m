//
//  MessageDetailVC.m
//  JYDS
//
//  Created by 大雨 on 2017/4/2.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MessageDetailVC.h"
#import "BaseWKWebView.h"
@interface MessageDetailVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kMessageDetail]];
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
