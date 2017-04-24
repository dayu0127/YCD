//
//  BaseNavViewController.m
//  JYDS
//
//  Created by liyu on 2016/12/31.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BaseNavViewController.h"
#import "BaseWKWebView.h"
@interface BaseNavViewController ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation BaseNavViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:_navTitle];
//    self.view.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
}

- (void)initNaBar:(NSString *)title{
    _navBar = [UIView new];
    _navBar.backgroundColor = ORANGERED;
    [self.view addSubview:_navBar];
    [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    //返回按钮
    _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_leftBarButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBarButton];
    [_leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(7);
        make.width.height.mas_equalTo(@33);
    }];
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.text = _navTitle;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [_leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBarButton);
        make.left.equalTo(self.leftBarButton).offset(8);
    }];
    //页面
    [YHHud showWithStatus];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) url:_linkUrl];
    [self.view addSubview:_wkWebView];
}
- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}
//- (void)returnToLogin{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线提醒" message:@"该账号已在其他设备上登录" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
//        [app.window setRootViewController:loginVC];
//        [app.window makeKeyWindow];
//    }]];
//    [self presentViewController:alert animated:YES completion:nil];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.view endEditing:YES];
//}
@end
