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
                //非游客登录
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isVisitor"];
                [self loginSuccess:json[@"data"]];
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
#pragma mark 游客登录
- (IBAction)visitorLogin:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"重要提示" message:@"亲爱的用户，您选择了游客模式登录应用，由于该模式下的用户数据（包括付费数据）在删除应用、更换设备后将被清空！对此造成的损失，本公司将不承担任何责任！\n我们强烈建议您使用手机号登录应用" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"继续游客登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *jsonDic = @{@"deviceNum":DEVICEID};
        
        [YHWebRequest YHWebRequestForPOST:kVisitorLogin parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                //非游客登录
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isVisitor"];
                [self loginSuccess:json[@"data"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)autoFillUserName:(NSString *)userName{
    _phoneText.text = userName;
}
- (IBAction)qqLogin:(id)sender {
    [self otherLogin:UMSocialPlatformType_QQ];
}
- (IBAction)weChatLogin:(id)sender {
    [self otherLogin:UMSocialPlatformType_WechatSession];
}
- (IBAction)sinaLogin:(id)sender {
    [self otherLogin:UMSocialPlatformType_Sina];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
