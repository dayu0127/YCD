//
//  SetVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SetVC.h"
#import "LoginNC.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import <UIImageView+WebCache.h>

@interface SetVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (nonatomic,strong) JCAlertView *alertView;

@end
@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-120) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _logoutButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (NSArray *)arr{
    if (!_arr) {
        _arr = @[@"夜间模式",@"清除缓存"];
    }
    return _arr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    cell.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 44)];
    label.text = self.arr[indexPath.row];
    label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    label.font = [UIFont systemFontOfSize:15.0f];
    [cell.contentView addSubview:label];
    if (indexPath.row==0) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake((WIDTH-67), 6.5, 51, 31)];
        [sw addTarget:self action:@selector(openNight:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isNightMode"]];
        [cell.contentView addSubview:sw];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [YHHud showWithStatus:@"正在清除"];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        [YHHud dismiss];
        [YHHud showWithSuccess:@"清除成功"];
    }
}
- (void)openNight:(UISwitch *)sender{
    if (sender.on == YES) {
        //开启夜间模式
        [DKNightVersionManager sharedManager].themeVersion = DKThemeVersionNight;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nightMode" object:nil];
    }else{
        //关闭夜间模式
        [DKNightVersionManager sharedManager].themeVersion = DKThemeVersionNormal;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dayMode" object:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"isNightMode"];
}
- (IBAction)logoutButtonClick:(UIButton *)sender {
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 100) title:@"确定退出登录?" message:nil];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"type":@"1"};
        [YHWebRequest YHWebRequestForPOST:LOGOUT parameters:dic success:^(NSDictionary *json) {
            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
                [app.window setRootViewController:loginVC];
                [app.window makeKeyWindow];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
            }else if([json[@"code"] isEqualToString:@"TYPEERR"]){
                [YHHud showWithMessage:@"该账号未登录"];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"退出登录失败"];
            }
        }];
    }
}
@end
