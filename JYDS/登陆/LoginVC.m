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

//@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
//@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //登录按钮
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 7.5f;
    _loginButton.layer.borderWidth = 1.0f;
    _loginButton.layer.borderColor = GRAYCOLOR.CGColor;
//    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [self nightModeConfiguration];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
//    _phoneText = [_textFieldCollection objectAtIndex:0];
//    _pwdText = [_textFieldCollection objectAtIndex:1];
//    if ([YHSingleton shareSingleton].userInfo!=nil) {
//        _phoneText.text = [YHSingleton shareSingleton].userInfo.userName;
//    }
}
//- (void)nightModeConfiguration{
//    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],N_BG,RED);
//    for (UITextField *item in _textFieldCollection) {
//        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
//    }
//    for (UIView *line in _lineCollection) {
//        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    }
//    _loginButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    for (UIButton *item in _buttonCollection) {
//        [item dk_setTitleColorPicker:DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED) forState:UIControlStateNormal];
//    }
//}
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
        _loginButton.layer.borderColor = GRAYCOLOR.CGColor;
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
#pragma mark 点击登录
- (IBAction)loginButtonClick:(UIButton *)sender {
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
        [YHHud showWithMessage:@"请输入有效的11位手机号"];
    }
//    else if (REGEX(PWD_RE, _pwdTxt.text)==NO){
//        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
//    }
    else{
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
        [YHHud showWithStatus:@"正在登陆"];
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
                [YHHud showWithMessage:json[@"message" ]];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud dismiss];
            NSLog(@"%@",error);
        }];
    }
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
//- (IBAction)visitorsToLogin:(id)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
//    [app.window setRootViewController:rootTBC];
//    [app.window makeKeyWindow];
//}
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
//                "nickName":"Winner.z"           #昵称(选填)
//            }
            NSString *associatedQq = resp.uid;
            NSString *genter = resp.gender;
            NSString *nickName = resp.name;
            NSDictionary *jsonDic = @{@"associatedQq" :associatedQq,             // #第三方绑定的uid 唯一标识
                                                  @"genter":genter,
                                                  @"nickName":nickName};               //   #性别 1男 0女  （选填
            [YHWebRequest YHWebRequestForPOST:kQQLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    NSLog(@"%@",json);
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
- (IBAction)weChatLogin:(id)sender {
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
//            }
            NSString *associatedWx = resp.uid;
            NSString *genter = resp.gender;
            NSString *nickName = resp.name;
            NSDictionary *jsonDic = @{@"associatedWx" :associatedWx,             // #第三方绑定的uid 唯一标识
                                                  @"genter":genter,               //   #性别 1男 0女  （选填
                                                  @"nickName":nickName};
            [YHWebRequest YHWebRequestForPOST:kWXLogin parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    [YHSingleton shareSingleton].userInfo.associatedWx = associatedWx;
                    [YHHud showWithSuccess:json[@"message"]];
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
