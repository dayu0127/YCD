//
//  LoginVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "LoginVC.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "RegisterVC.h"
#import <UMSocialCore/UMSocialCore.h>
@interface LoginVC ()<RegisterVCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@end

@implementation LoginVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //登录按钮
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 7.5f;
    _loginButton.layer.borderWidth = 1.0f;
    _loginButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
}
- (IBAction)backToHome:(id)sender {
    [self returnToHome];
}
- (IBAction)codeLoginClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnToHome{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
    [app.window setRootViewController:rootTBC];
    [app.window makeKeyWindow];
}
- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length==0) {
        _loginButton.enabled = NO;
        [_loginButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        _loginButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    }else if(sender.text.length>0&&sender.text.length<=11){
        _loginButton.enabled = YES;
        [_loginButton setTitleColor:ORANGERED forState:UIControlStateNormal];
        _loginButton.layer.borderColor = ORANGERED.CGColor;
    }else {
        sender.text = [sender.text substringToIndex:11];
    }
}
- (IBAction)pwdEditingChanged:(UITextField *)sender {
    if (sender.text.length > 15) {
        sender.text = [sender.text substringToIndex:15];
    }
}
#pragma mark 按钮按下事件
- (IBAction)loginButtonTouchDown:(UIButton *)sender {
    sender.backgroundColor = ORANGERED;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.selected = YES;
}
#pragma mark 按钮松开事件
- (IBAction)loginButtonTouchUpOutside:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    [sender setTitleColor:ORANGERED forState:UIControlStateNormal];
    sender.selected = NO;
}
#pragma mark 密码登录
- (IBAction)loginButtonClick:(UIButton *)sender {
//    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
//        [YHHud showWithMessage:@"请输入有效的11位手机号"];
//    }else{
        //    {
        //        "phoneNum":"13300001111",#手机号
        //        "password":"123456",     #密码
        //        "deviceNum":"123456",    #设备码（选填）
        //        "deviceType":"ios",      #设备类型（选填）
        //        "deviceSize":"5.5"       #设备尺寸（选填）
        //        "deviceOem":"iPhone6s",  #设备名称（选填）
        //        "deviceOs" :"5.1.1"      #设备操作系统（选填）
        //    }
        //--实现登录--
        [YHHud showWithStatus];
        NSString *phoneNum = _phoneText.text;
        NSString *password = _pwdTxt.text;
        NSDictionary *jsonDic = @{
            @"phoneNum" :phoneNum,             // #用户名
            @"password":password,               //    #密码
            @"deviceNum":DEVICEID,    //#设备码（选填）
        };
        [YHWebRequest YHWebRequestForPOST:kPwdLogin parameters:jsonDic success:^(NSDictionary *json) {
            [YHHud dismiss];
            if ([json[@"code"] integerValue] == 200) {
//                NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
                //改变我的页面，显示头像,昵称和手机号
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                //保存token
                [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
                //保存用户信息
                [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"user"] forKey:@"userInfo"];
                [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:dataDic[@"user"]];
                //保存登录保存登录状态
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                //登录成功跳转首页
                [YHHud showWithSuccess:@"登录成功"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self returnToHome];
//                });
                [self getBannerInfo];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud dismiss];
            NSLog(@"%@",error);
        }];
//    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"register"]) {
        RegisterVC *registerVC = segue.destinationViewController;
        registerVC.delegate = self;
    }
}
- (void)autoFillUserName:(NSString *)userName{
    _phoneText.text = userName;
}
- (IBAction)qqLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            
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
            NSDictionary *jsonDic = @{
                @"associatedQq" :resp.uid,             // #第三方绑定的uid 唯一标识
                @"headImg":headImg,        //           #头像url（选填）
                @"nickName":resp.name        //         #昵称（选填）
            };
            [YHWebRequest YHWebRequestForPOST:kQQLogin parameters:jsonDic success:^(NSDictionary *json) {
                NSLog(@"%@",json);
                if ([json[@"code"] integerValue] == 200) {
//                    NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
                    //改变我的页面，显示头像,昵称和手机号
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    //保存token
                    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
                    //保存用户信息
                    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"user"] forKey:@"userInfo"];
                    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:dataDic[@"user"]];
                    //保存登录类型
                    [[NSUserDefaults standardUserDefaults] setObject:@"qq" forKey:@"loginType"];
                    //改变登录状态
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    [YHHud showWithSuccess:@"登录成功"];
                    [self getBannerInfo];
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
- (IBAction)weChatLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
//            {
//                "associatedWx":"dfdsfsdfsdf"    #第三方绑定的uid 唯一标识
//                "country":"",                   #国家（选填）
//                "province":"",                  #省市（选填）
//                "city":"",                      #城市（选填）
//                "genter":""                     #性别 1男 0女  （选填）
//            }
            //微信登录
            NSString *headImg = resp.iconurl;
            NSMutableString *iconUrl = [NSMutableString stringWithString:resp.iconurl];
            if (![[iconUrl substringToIndex:4] isEqualToString:@"https"]) {
                [iconUrl replaceCharactersInRange:NSMakeRange(0, 4) withString:@"https"];
                headImg = [NSString stringWithString:iconUrl];
            }
            NSDictionary *jsonDic = @{
                @"associatedWx" :resp.uid,             // #第三方绑定的uid 唯一标识
                @"headImg":headImg,        //           #头像url（选填）
                @"nickName":resp.name        //         #昵称（选填）
            };
            [YHWebRequest YHWebRequestForPOST:kWXLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
//                    NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
                    //改变我的页面，显示头像,昵称和手机号
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    //保存token
                    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
                    //保存用户信息
                    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"user"] forKey:@"userInfo"];
                    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:dataDic[@"user"]];
                    //保存登录类型
                    [[NSUserDefaults standardUserDefaults] setObject:@"wx" forKey:@"loginType"];
                    //改变登录状态
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    [YHHud showWithSuccess:@"登录成功"];
                    [self getBannerInfo];
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
- (IBAction)sinaLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
//            {
//                "associatedWx":"dfdsfsdfsdf"    #第三方绑定的uid 唯一标识
//                "country":"",                   #国家（选填）
//                "province":"",                  #省市（选填）
//                "city":"",                      #城市（选填）
//                "genter":""                     #性别 1男 0女  （选填）
//            }
            //新浪微博登录
            NSString *headImg = resp.iconurl;
            NSMutableString *iconUrl = [NSMutableString stringWithString:resp.iconurl];
            if (![[iconUrl substringToIndex:4] isEqualToString:@"https"]) {
                [iconUrl replaceCharactersInRange:NSMakeRange(0, 4) withString:@"https"];
                headImg = [NSString stringWithString:iconUrl];
            }
            NSDictionary *jsonDic = @{
                @"associatedWx" :resp.uid,             // #第三方绑定的uid 唯一标识
                @"headImg":headImg,        //           #头像url（选填）
                @"nickName":resp.name        //         #昵称（选填）
            };
            [YHWebRequest YHWebRequestForPOST:kWBLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    //                    NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
                    //改变我的页面，显示头像,昵称和手机号
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    //保存token
                    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
                    //保存用户信息
                    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"user"] forKey:@"userInfo"];
                    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:dataDic[@"user"]];
                    //保存登录类型
                    [[NSUserDefaults standardUserDefaults] setObject:@"wb" forKey:@"loginType"];
                    //改变登录状态
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    [YHHud showWithSuccess:@"登录成功"];
                    [self getBannerInfo];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
