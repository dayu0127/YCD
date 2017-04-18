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
@property (weak, nonatomic) IBOutlet UIImageView *login_code_img;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxt;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceForImageCode;
@property (strong,nonatomic) NSTimer *countDownTimer;
@property (assign,nonatomic)int countDown;
@end

@implementation LoginCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 7.5f;
    _loginButton.layer.borderWidth = 1.0f;
    _loginButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    //默认图形验证码隐藏
    _login_code_img.alpha = 0;
    _imgCodeTxt.alpha = 0;
    _codeImage.alpha = 0;
    _line2.alpha = 0;
    _spaceForImageCode.constant = 22;
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
#pragma mark 获取验证码
- (IBAction)getCodeClick:(UIButton *)sender {
    
    //点击显示图形验证(测试环境)
//    _login_code_img.alpha = 1;
//    _imgCodeTxt.alpha = 1;
//    _codeImage.alpha = 1;
//    _line2.alpha = 1;
//    _spaceForImageCode.constant = 80;
//    {
//        "phoneNum":"13300001111",  #手机号
//        "stype":1,                 #类型  1注册 2登录 3找回密码
//        "deviceNum":"123456",      #设备码（选填）
//    }
    //验证码按钮倒计时
    _countDown = COUNTDOWN;
    sender.enabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
    [sender setTitle:[NSString stringWithFormat:@"%ds",_countDown] forState:UIControlStateNormal];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _countDown--;
        [sender setTitle:[NSString stringWithFormat:@"%ds",_countDown] forState:UIControlStateNormal];
        if (_countDown == 0) {
            [timer invalidate];
            sender.enabled = YES;
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
//            sender.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
            sender.backgroundColor = ORANGERED;
        }
    }];
    NSString *phoneNum = _phoneTxt.text;
    NSDictionary *jsonDic = @{@"phoneNum" :phoneNum,             // #用户名
                                          @"stype":@"2",               //    #类型  1注册 2登录 3找回密码
                                          @"deviceNum":DEVICEID};               //     #设备码（选填）
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            [YHHud showWithSuccess:json[@"message"]];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 验证码登录按钮点击事件
- (IBAction)loginButtonClick:(id)sender {
//    {
//        "phoneNum":"13300001111",#手机号
//        "verifyCode":"123456"    #验证码
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSString *verifyCode = _checkCodeTxt.text;
    NSDictionary *jsonDic = @{@"phoneNum" :phoneNum,             // #用户名
                                          @"verifyCode":verifyCode};               //    #验证码
    [YHWebRequest YHWebRequestForPOST:kCodeLogin parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self returnToHome];
            });
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
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
            NSString *nickName = resp.name;
            NSDictionary *jsonDic = @{@"associatedQq" :associatedQq,             // #第三方绑定的uid 唯一标识
                                                  @"genter":genter,
                                                  @"nickName":nickName};               //   #性别 1男 0女  （选填
            [YHWebRequest YHWebRequestForPOST:kQQLogin parameters:jsonDic success:^(NSDictionary *json) {
                NSLog(@"%@",json);
                if ([json[@"code"] integerValue] == 200) {
                    [YHSingleton shareSingleton].userInfo.associatedQq = associatedQq;
                    [YHHud showWithSuccess:@"登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self returnToHome];
                    });
                }else{
                    NSLog(@"%@",json[@"code"]);
                    NSLog(@"%@",json[@"message"]);
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }];
}
- (IBAction)wxLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
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
            //                "nickName":"Winner.z"           #昵称(选填)
            //            }
            NSString *associatedWx = resp.uid;
            NSString *genter = resp.gender;
            NSString *nickName = resp.name;
            NSDictionary *jsonDic = @{@"associatedWx" :associatedWx,             // #第三方绑定的uid 唯一标识
                                                 @"genter":genter,
                                                 @"nickName":nickName};               //   #性别 1男 0女  （选填
            [YHWebRequest YHWebRequestForPOST:kWXLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    [YHSingleton shareSingleton].userInfo.associatedWx = associatedWx;
                    [YHHud showWithSuccess:@"登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self returnToHome];
                    });
                }else{
                    NSLog(@"%@",json[@"code"]);
                    NSLog(@"%@",json[@"message"]);
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }];
}

@end
