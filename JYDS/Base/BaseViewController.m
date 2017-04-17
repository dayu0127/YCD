//
//  BaseViewController.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()
@end
@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    _phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
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
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
        [app.window setRootViewController:loginVC];
        [app.window makeKeyWindow];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
