//
//  SetVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SetVC.h"
#import <UIImageView+WebCache.h>
#import "SetCell0.h"
#import "SetCell1.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *arr;
@property (nonatomic,strong) JCAlertView *alertView;

@end
@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell0" bundle:nil] forCellReuseIdentifier:@"SetCell0"];
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell1" bundle:nil] forCellReuseIdentifier:@"SetCell1"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSArray *)arr{
    if (!_arr) {
        _arr = @[@"夜间模式",@"清除缓存"];
    }
    return _arr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SetCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell0" forIndexPath:indexPath];
        cell.titleLabel0.text = @"账号设置";
        [cell setCellWithString:@""];
        cell.bingingLabel.alpha = 0;
        return cell;
    }else if (indexPath.row == 1){
        SetCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell0" forIndexPath:indexPath];
        cell.titleLabel0.text = @"清除缓存";
        [cell setCellWithString:@"0k"];
        cell.titleLabel1.text = @"666k";
        cell.titleLabel1.textColor = ORANGERED;
        return cell;
    }else{
        SetCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell1" forIndexPath:indexPath];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"toAccountSet" sender:self];
    }else if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [YHHud showWithStatus];
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
//- (IBAction)logoutButtonClick:(UIButton *)sender {
//    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 100) title:@"确定退出登录?" message:nil];
//    alertView.delegate = self;
//    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
//    [_alertView show];
//}
//- (void)buttonClickIndex:(NSInteger)buttonIndex{
//    [_alertView dismissWithCompletion:nil];
//    if (buttonIndex == 1) {
//        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
//        [YHWebRequest YHWebRequestForPOST:LOGOUT parameters:dic success:^(NSDictionary *json) {
//            if ([json[@"code"] isEqualToString:@"SUCCESS"]||[json[@"code"] isEqualToString:@"TYPEERR"]) {
//                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
//                [app.window setRootViewController:loginVC];
//                [app.window makeKeyWindow];
//                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
//            }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                [YHHud showWithMessage:@"服务器错误"];
//            }else{
//                [YHHud showWithMessage:@"退出登录失败"];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            [YHHud showWithMessage:@"数据请求失败"];
//        }];
//    }
//}
@end
