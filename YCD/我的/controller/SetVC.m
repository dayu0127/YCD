//
//  SetVC.m
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SetVC.h"
#import "Singleton.h"
#import "LoginNC.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import <JCAlertView.h>
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutButtonClick:(UIButton *)sender;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-120) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_logoutButton dk_setTitleColorPicker:DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]) forState:UIControlStateNormal];
}
- (NSArray *)arr{
    if (!_arr) {
        _arr = @[@"夜间模式",@"清除缓存"];
    }
    return _arr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    headView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor groupTableViewBackgroundColor],[UIColor darkGrayColor],[UIColor redColor]);
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 44)];
    label.text = self.arr[indexPath.section];
    label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    label.font = [UIFont systemFontOfSize:15.0f];
    [cell.contentView addSubview:label];
    if (indexPath.section==0) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake((WIDTH-67), 6.5, 51, 31)];
        [sw addTarget:self action:@selector(openNight:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isNightMode"]];
        [cell.contentView addSubview:sw];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)openNight:(UISwitch *)sender{
    if (sender.on == YES) {
        //开启夜间模式
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [UINavigationBar appearance].titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [UITableView appearance].sectionIndexColor = [UIColor whiteColor];
        [DKNightVersionManager sharedManager].themeVersion = DKThemeVersionNight;
    }else{
        //关闭夜间模式
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UINavigationBar appearance].titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [UITableView appearance].sectionIndexColor = [UIColor darkGrayColor];
        [DKNightVersionManager sharedManager].themeVersion = DKThemeVersionNormal;
    }
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"isNightMode"];
}

- (IBAction)logoutButtonClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
        [app.window setRootViewController:loginVC];
        [app.window makeKeyWindow];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
//    [JCAlertView showOneButtonWithTitle:@"title" Message:@"message" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"button" Click:^{
//        NSLog(@"click0");
//    }];
//    [JCAlertView showMultipleButtonsWithTitle:@"title" Message:@"message" Click:^(NSInteger index) {
//        NSLog(@"click%zi", index);
//    } Buttons:@{@(JCAlertViewButtonTypeDefault):@"index = 0"},@{@(JCAlertViewButtonTypeCancel):@"index = 1"},@{@(JCAlertViewButtonTypeWarn):@"index = 2"}, nil];
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 410)];
//    customView.backgroundColor = [UIColor cyanColor];
//    JCAlertView *customAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
//    NSLog(@"%@",NSStringFromCGRect(customView.frame));
//    [customAlert show];
}
@end
