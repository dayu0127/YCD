//
//  BaseNavViewController.m
//  JYDS
//
//  Created by liyu on 2016/12/31.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()
@end

@implementation BaseNavViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:_navTitle];
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
}

- (void)initNaBar:(NSString *)title{
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    _navBar.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.center = CGPointMake(WIDTH * 0.5, 42);
    [_navBar addSubview:titleLabel];
    _titleLabel = titleLabel;
    //返回按钮
    _leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    _leftBarButton.hidden = YES;
    [_leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    _leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftBarButton sizeToFit];
    [_leftBarButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:_leftBarButton];
    [self.view addSubview:_navBar];
}
- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)returnToLogin{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线提醒" message:@"该账号已在其他设备上登录" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
