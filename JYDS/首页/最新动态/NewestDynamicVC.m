//
//  NewestDynamicVC.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "NewestDynamicVC.h"
#import "BaseWKWebView.h"
@interface NewestDynamicVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation NewestDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [YHHud showWithStatus];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) url:_linkUrl];
    [self.view addSubview:_wkWebView];
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
