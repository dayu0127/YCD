//
//  BaseViewController.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "BaseViewController.h"
#import "BingingPhoneVC.h"
@interface BaseViewController ()
@end
@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userDic!=nil) {
        [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        _phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
        _associatedWx = [YHSingleton shareSingleton].userInfo.associatedWx;
        _associatedQq = [YHSingleton shareSingleton].userInfo.associatedQq;
        _associatedWb = [YHSingleton shareSingleton].userInfo.associatedWb;
    }
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)returnToLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self popToLogin];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)returnToBingingPhone{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先绑定手机" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BingingPhoneVC *bingingvc = [sb instantiateViewControllerWithIdentifier:@"bingingPhone"];
        [self.navigationController pushViewController:bingingvc animated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)popToLogin{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginVC];
    [app.window makeKeyWindow];
}
- (void)loadNoInviteView:(NSString *)str{
    _label = [UILabel new];
    _label.text = str;
    _label.textColor = LIGHTGRAYCOLOR;
    _label.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(289/667.0*HEIGHT);
        make.centerX.equalTo(self.view);
    }];
}
- (void)loginInterceptCompletion:(void(^)(void))completion{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token == nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
        completion();
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
