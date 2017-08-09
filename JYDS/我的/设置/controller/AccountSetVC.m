//
//  AccountSetVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "AccountSetVC.h"

#import "SetCell0.h"
#import <UMSocialCore/UMSocialCore.h>
#import "BingingPhoneVC.h"
#import <UIImageView+WebCache.h>
@interface AccountSetVC ()<UITableViewDataSource,UITableViewDelegate,BingingPhoneVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell0" bundle:nil] forCellReuseIdentifier:@"SetCell0"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell0" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel0.text = @"修改密码";
        [cell setCellWithString:@""];
        cell.bingingLabel.alpha = 0;
    }else if (indexPath.row == 1) {
        cell.titleLabel0.text = @"手机号码";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.phoneNum];
    }else if (indexPath.row == 2){
        cell.titleLabel0.text = @"微信账号";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.associatedWx];
    }else if(indexPath.row == 3){
        cell.titleLabel0.text = @"QQ账号";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.associatedQq];
    }else{
        cell.titleLabel0.text = @"微博账号";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.associatedWb];
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)otherBinging:(UMSocialPlatformType)platformType indexPath:(NSIndexPath *)indexPath{
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"][@"phoneNum"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if ([phoneNum isEqualToString:@""]&&token == nil) {
        [YHHud showWithMessage:@"请先绑定手机"];
    }else{
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                UMSocialUserInfoResponse *resp = result;
                NSString *associated = resp.uid;
                NSDictionary *jsonDic = [NSDictionary dictionary];
                NSString *APIStr = @"";
                if (platformType == UMSocialPlatformType_QQ) {
                    jsonDic = @{
                                @"phoneNum":phoneNum,      // #用户手机号
                                @"token":token,            //   #令牌
                                @"associatedQq":associated  // #第三方绑定的uid 唯一标识
                                };
                    APIStr = kBindingQQ;
                }else if(platformType == UMSocialPlatformType_WechatSession){
                    jsonDic = @{
                                @"phoneNum":phoneNum,      // #用户手机号
                                @"token":token,            //   #令牌
                                @"associatedWx":associated  // #第三方绑定的uid 唯一标识
                                };
                    APIStr = kBindingWX;
                }else{
                    jsonDic = @{
                                @"phoneNum":phoneNum,      // #用户手机号
                                @"token":token,            //   #令牌
                                @"associatedWb":associated  // #第三方绑定的uid 唯一标识
                                };
                    APIStr = kBindingWB;
                }
                [YHWebRequest YHWebRequestForPOST:APIStr parameters:jsonDic success:^(NSDictionary *json) {
                    if ([json[@"code"] integerValue] == 200) {
                        [YHHud showWithMessage:@"绑定成功"];
                        if (platformType == UMSocialPlatformType_QQ) {
                            [YHSingleton shareSingleton].userInfo.associatedQq = associated;
                        }else if(platformType == UMSocialPlatformType_WechatSession){
                            [YHSingleton shareSingleton].userInfo.associatedWx = associated;
                        }else{
                            [YHSingleton shareSingleton].userInfo.associatedWb = associated;
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        NSLog(@"%@",json[@"code"]);
                        [YHHud showWithMessage:json[@"message"]];
                    }
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isVisitor"] == NO) {
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"][@"phoneNum"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if (indexPath.row == 0) {
            if ([phoneNum isEqualToString:@""]&&token == nil) {
                [YHHud showWithMessage:@"请先绑定手机"];
            }else{
                [self performSegueWithIdentifier:@"toModifyPwdVC" sender:self];
            }
        }else if (indexPath.row == 1) {//手机号绑定
            if ([phoneNum isEqualToString:@""]&&token == nil) {
                [self performSegueWithIdentifier:@"toBingingPhone" sender:self];
            }
        }else if (indexPath.row == 2) {//微信绑定
            if ([self.associatedWx isEqualToString:@""]) {
                [self otherBinging:UMSocialPlatformType_WechatSession indexPath:indexPath];
            }
        }else if(indexPath.row == 3){//QQ绑定
            if ([self.associatedQq isEqualToString:@""]) {
                [self otherBinging:UMSocialPlatformType_QQ indexPath:indexPath];
            }
        }else{ //微博绑定
            if ([self.associatedWb isEqualToString:@""]) {
                [self otherBinging:UMSocialPlatformType_Sina indexPath:indexPath];
            }
        }
    }else{
        [YHHud showWithMessage:@"游客登录不支持该功能"];
    }
}
#pragma mark 退出当前账号
- (IBAction)logoutClick:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isVisitor"] == NO) {
        //清空token
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        //清空个人信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        //清除个人点赞
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"likesDic"];
        //清空个人消息数
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeCountDic"];
    }
    //清除缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    //改变登录状态
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    //跳转到登录页面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginVC];
    [app.window makeKeyWindow];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toBingingPhone"]) {
        BingingPhoneVC *bingingPhoneVC = segue.destinationViewController;
        bingingPhoneVC.delegate = self;
    }
}
- (void)updatePhoneBingingState:(NSString *)phone{
    [YHSingleton shareSingleton].userInfo.phoneNum = phone;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
@end
