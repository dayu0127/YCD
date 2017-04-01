//
//  LoginCodeVC.m
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "LoginCodeVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RootTabBarController.h"
@interface LoginCodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTxt;

@end

@implementation LoginCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 7.5f;
    _loginButton.layer.borderWidth = 1.0f;
    _loginButton.layer.borderColor = GRAYCOLOR.CGColor;
}

- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length==0) {
        _loginButton.enabled = NO;
        [_loginButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        _loginButton.layer.borderColor = GRAYCOLOR.CGColor;
    }else if(sender.text.length>0&&sender.text.length<=11){
        _loginButton.enabled = YES;
        [_loginButton setTitleColor:ORANGERED forState:UIControlStateNormal];
        _loginButton.layer.borderColor = ORANGERED.CGColor;
    }else {
        sender.text = [sender.text substringToIndex:11];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backToHome:(id)sender {
    [self returnToHome];
}
- (void)returnToHome{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
    [app.window setRootViewController:rootTBC];
    [app.window makeKeyWindow];
}
- (IBAction)getCodeClick:(id)sender {
//    {
//        "phoneNum":"13300001111",  #手机号
//        "stype":1,                 #类型  1注册 2登录 3找回密码
//        "deviceNum":"123456",      #设备码（选填）
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSDictionary *jsonDic = @{
                                      @"phoneNum" :phoneNum,             // #用户名
                                      @"stype":@"2",               //    #类型  1注册 2登录 3找回密码
                                      @"deviceNum":DEVICEID,               //     #设备码（选填）
                                      };
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            [YHHud showWithSuccess:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)loginButtonClick:(id)sender {
//    {
//        "phoneNum":"13300001111",#手机号
//        "verifyCode":"123456"    #验证码
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSString *verifyCode = _checkCodeTxt.text;
    NSDictionary *jsonDic = @{@"phoneNum" :phoneNum,             // #用户名
                                          @"verifyCode":verifyCode,               //    #验证码
                                      };
    [YHWebRequest YHWebRequestForPOST:kCodeLogin parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
            //改变我的页面，显示头像,昵称和手机号
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            //保存token
            [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
            //保存用户信息
            [YHSingleton shareSingleton].userInfo.phoneNum = dataDic[@"user"][@"phoneNum"]; //手机号
            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
            //保存登录保存登录状态
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            //登录成功跳转首页
            [YHHud showWithSuccess:@"登录成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self returnToHome];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)qqLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
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
            //            }
            NSString *associatedQq = resp.uid;
            NSString *genter = resp.gender;
            NSDictionary *jsonDic = @{
                                              @"associatedQq" :associatedQq,             // #第三方绑定的uid 唯一标识
                                              @"genter":genter               //   #性别 1男 0女  （选填
                                              };
            [YHWebRequest YHWebRequestForPOST:kQQLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    [YHSingleton shareSingleton].userInfo.associatedQq = associatedQq;
                    [YHHud showWithSuccess:@"登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self returnToHome];
                    });
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }];
}
- (IBAction)wxLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        NSLog(@"---------%@",result);
        NSLog(@"---------------------------%@",error);
        if (error) {

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
            NSString *associatedWx = resp.uid;
            NSString *genter = resp.gender;
            NSDictionary *jsonDic = @{@"associatedWx" :associatedWx,             // #第三方绑定的uid 唯一标识
                                                 @"genter":genter};               //   #性别 1男 0女  （选填
            
            [YHWebRequest YHWebRequestForPOST:kQQLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    [YHSingleton shareSingleton].userInfo.associatedWx = associatedWx;
                    [YHHud showWithSuccess:@"登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self returnToHome];
                    });
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }];
}

@end
