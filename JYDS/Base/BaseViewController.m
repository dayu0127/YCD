//
//  BaseViewController.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "BaseViewController.h"
#import "BingingPhoneVC.h"
#import "RootTabBarController.h"

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
- (void)returnToHome{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
    [app.window setRootViewController:rootTBC];
    [app.window makeKeyWindow];
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
- (void)getBannerInfo{
    //获取首页内容
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum!=nil ? [YHSingleton shareSingleton].userInfo.phoneNum : @"";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]!=nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] : @"";
    NSDictionary *jsonDic = @{
                              @"userPhone":phoneNum,      //  #用户手机号
                              @"token":token        //    #用户登陆凭证
                              };
    [YHWebRequest YHWebRequestForPOST:kBanner parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:@"banner"];
            [self returnToHome];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    }failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)otherLogin:(UMSocialPlatformType)platformType{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
//            // 授权信息
//            NSLog(@"QQ uid: %@", resp.uid);
//            NSLog(@"QQ openid: %@", resp.openid);
//            NSLog(@"QQ accessToken: %@", resp.accessToken);
//            NSLog(@"QQ expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"QQ name: %@", resp.name);
//            NSLog(@"QQ iconurl: %@", resp.iconurl);
//            NSLog(@"QQ gender: %@", resp.gender);
//            
//            // 第三方平台SDK源数据
//            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            
            //            {
            //                "associatedQq":"dfdsfsdfsdf",   #第三方绑定的uid 唯一标识
            //                "country":"",                   #国家（选填）
            //                "province":"",                  #省市（选填）
            //                "city":"",                      #城市（选填）
            //                "genter":""                     #性别 1男 0女  （选填）
            //                "nickName":"Winner.z"           #昵称(选填)
            //            }
            NSString *headImg = resp.iconurl;
            NSMutableString *iconUrl = [NSMutableString stringWithString:resp.iconurl];
            if (![[iconUrl substringToIndex:4] isEqualToString:@"https"]) {
                [iconUrl replaceCharactersInRange:NSMakeRange(0, 4) withString:@"https"];
                headImg = [NSString stringWithString:iconUrl];
            }
            NSDictionary *jsonDic = [NSDictionary dictionary];
            NSString *APIStr = @"";
            NSString *loginType = @"";
            if (platformType == UMSocialPlatformType_QQ) {
                jsonDic = @{
                   @"associatedQq" :resp.uid,             // #第三方绑定的uid 唯一标识
                   @"headImg":headImg,        //           #头像url（选填）
                   @"nickName":resp.name        //         #昵称（选填）
               };
                APIStr = kQQLogin;
                loginType = @"qq";
            }else if(platformType == UMSocialPlatformType_WechatSession){
                jsonDic = @{
                    @"associatedWx" :resp.uid,             // #第三方绑定的uid 唯一标识
                    @"headImg":headImg,        //           #头像url（选填）
                    @"nickName":resp.name        //         #昵称（选填）
                };
                APIStr = kWXLogin;
                loginType = @"wx";
            }else{
                jsonDic = @{
                    @"associatedWb" :resp.uid,             // #第三方绑定的uid 唯一标识
                    @"headImg":headImg,        //           #头像url（选填）
                    @"nickName":resp.name        //         #昵称（选填）
                };
                APIStr = kWBLogin;
                loginType = @"wb";
            }
            [YHWebRequest YHWebRequestForPOST:APIStr parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    //保存第三方登录类型
                    [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:@"loginType"];
                    //非游客登录
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isVisitor"];
                    [self loginSuccess:json[@"data"]];
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
- (void)loginSuccess:(NSString *)jsonString{
    //改变我的页面，显示头像,昵称和手机号
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
    NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:jsonString];
    //保存token
    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
    //保存用户信息
    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"user"] forKey:@"userInfo"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"]!=nil) {
        //清除个人点赞
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"likesDic"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"noticeCountDic"]!=nil) {
        //清空个人消息数
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeCountDic"];
    }
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:dataDic[@"user"]];
    //改变登录状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [YHHud showWithSuccess:@"登录成功"];
    [self getBannerInfo];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
