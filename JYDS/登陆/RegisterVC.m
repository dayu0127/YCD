//
//  RegisterVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "RegisterVC.h"
#import "UserAgreementVC.h"
@interface RegisterVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (strong,nonatomic)NSTimer *countDownTimer;
@property (assign,nonatomic)int countDown;
@property (weak, nonatomic) IBOutlet UIImageView *login_code_img;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxt;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceForImageCheck;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *invitationPhoneTxt;
@end

@implementation RegisterVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _registerButton.layer.masksToBounds = YES;
    _registerButton.layer.cornerRadius = 7.5f;
    _registerButton.layer.borderWidth = 1.0f;
    _registerButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    //默认图形验证码隐藏
    _login_code_img.alpha = 0;
    _imgCodeTxt.alpha = 0;
    _codeImage.alpha = 0;
    _line2.alpha = 0;
    _spaceForImageCheck.constant = 22;
}
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 监听是否输入11位手机号，改变验证码按钮状态
- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length==0) {
        _registerButton.enabled = NO;
        [_registerButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        _registerButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    }else if(sender.text.length>0&&sender.text.length<=11){
        _registerButton.enabled = YES;
        [_registerButton setTitleColor:ORANGERED forState:UIControlStateNormal];
        _registerButton.layer.borderColor = ORANGERED.CGColor;
    }else {
        sender.text = [sender.text substringToIndex:11];
    }
}
//#pragma mark 限制验证码长度不能超过6位
//- (IBAction)idCodeEditingChanged:(UITextField *)sender {
//    if (sender.text.length>4) {
//        sender.text = [sender.text substringToIndex:4];
//    }
//}
#pragma mark 限制密码长度不能超过15位
- (IBAction)pwdEditingChanged:(UITextField *)sender {
    if (sender.text.length>15) {
        sender.text = [sender.text substringToIndex:15];
    }
}
#pragma mark 验证码按钮点击
- (IBAction)checkButtonClick:(UIButton *)sender {
//    运营商号段如下：
//    中国移动号码：134、135、136、137、138、139、147（无线上网卡）、150、151、152、157、158、159、182、183、187、188、178
//    中国联通号码：130、131、132、145（无线上网卡）、155、156、185（iPhone5上市后开放）、186、176（4G号段）、175（2015年9月10日正式启用，暂只对北京、上海和广东投放办理）
//    中国电信号码：133、153、180、181、189、177、173、149
//    虚拟运营商：170、1718、1719
    //点击显示图形验证(测试环境)
//    _login_code_img.alpha = 1;
//    _imgCodeTxt.alpha = 1;
//    _codeImage.alpha = 1;
//    _line2.alpha = 1;
//    _spaceForImageCheck.constant = 80;
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
//    {
//        "phoneNum":"13300001111",  #手机号
//        "stype":1,                 #类型  1注册 2登录 3找回密码
//        "deviceNum":"123456",      #设备码（选填）
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSDictionary *jsonDic = @{
        @"phoneNum" :phoneNum,             // #用户名
        @"stype":@"1",               //    #类型  1注册 2登录 3找回密码
        @"deviceNum":DEVICEID             //     #设备码（选填）
    };
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        NSLog(@"%@",json[@"code"]);
        [YHHud showWithMessage:json[@"message"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)registerButtonClick:(UIButton *)sender {
    NSString *password = [_pwdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([password isEqualToString:@""]&&password.length<6) {
        [YHHud showWithMessage:@"密码长度不能低于6位"];
    }else{
        //注册
        NSString *phoneNum = _phoneTxt.text;
        NSString *verifyCode = _checkCodeTxt.text;
        NSString *invitePhoneNum = _invitationPhoneTxt.text;
        NSDictionary *jsonDic = @{
            @"phoneNum" :phoneNum,             // #用户名
            @"verifyCode":verifyCode,               //    #验证码
            @"password":password,               //    #密码
            @"invitePhoneNum" :invitePhoneNum     //#推荐人手机号
        };
        [YHWebRequest YHWebRequestForPOST:kRegister parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                [YHHud showWithSuccess:@"注册成功"];
                [_delegate autoFillUserName:_phoneTxt.text];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    
}
@end
