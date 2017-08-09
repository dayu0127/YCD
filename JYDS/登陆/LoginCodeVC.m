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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
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
- (IBAction)backToPwdLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            sender.backgroundColor = ORANGERED;
        }
    }];
    NSString *phoneNum = _phoneTxt.text;
    //发送验证码
    NSDictionary *jsonDic = @{
        @"phoneNum" :phoneNum,             // #用户名
        @"stype":@"2",               //    #类型  1注册 2登录 3找回密码
        @"deviceNum":DEVICEID               //     #设备码（选填）
    };
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        NSLog(@"%@",json[@"code"]);
        [YHHud showWithMessage:json[@"message"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 验证码登录
- (IBAction)loginButtonClick:(id)sender {
//    if (REGEX(PHONE_RE, _phoneTxt.text)==NO) {
//        [YHHud showWithMessage:@"请输入有效的11位手机号"];
//    }else{
        NSString *phoneNum = _phoneTxt.text;
        NSString *verifyCode = _checkCodeTxt.text;
        //验证码登录
        NSDictionary *jsonDic = @{
            @"phoneNum" :phoneNum,             // #手机号
            @"verifyCode":verifyCode              //    #验证码
        };
        [YHWebRequest YHWebRequestForPOST:kCodeLogin parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
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
//    }
}
- (IBAction)qqLogin:(id)sender {
    [self otherLogin:UMSocialPlatformType_QQ];
}
- (IBAction)wxLogin:(id)sender {
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
