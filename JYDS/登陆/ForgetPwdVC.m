//
//  ForgetPwdVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "ForgetPwdVC.h"
#import <SMS_SDK/SMSSDK.h>
@interface ForgetPwdVC ()
//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
//@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
//@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UIImageView *login_code_img;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTxt;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceForImageCheck;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//@property (strong,nonatomic) UITextField *phoneText;
//@property (strong,nonatomic) UITextField *idCodeText;
//@property (strong,nonatomic) UITextField *pwdText;
@property (strong,nonatomic)NSTimer *countDownTimer;
@property (assign,nonatomic)int countDown;

@end

@implementation ForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 7.5f;
    _sureButton.layer.borderWidth = 1.0f;
    _sureButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    //默认图形验证码隐藏
    _login_code_img.alpha = 0;
    _imgCodeTxt.alpha = 0;
    _codeImage.alpha = 0;
    _line2.alpha = 0;
    _spaceForImageCheck.constant = 22;
//    [self nightModeConfiguration];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
//    _submitButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    _phoneText = [_textFieldCollection objectAtIndex:0];
//    _idCodeText = [_textFieldCollection objectAtIndex:1];
//    _pwdText = [_textFieldCollection objectAtIndex:2];
}
//- (void)nightModeConfiguration{
//    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],N_BG,RED);
//    for (UILabel *item in _labelCollection) {
//        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
//    }
//    for (UITextField *item in _textFieldCollection) {
//        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
//    }
//    for (UIView *line in _lineCollection) {
//        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    }
//}
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length==0) {
        _sureButton.enabled = NO;
        [_sureButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        _sureButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    }else if(sender.text.length>0&&sender.text.length<=11){
        _sureButton.enabled = YES;
        [_sureButton setTitleColor:ORANGERED forState:UIControlStateNormal];
        _sureButton.layer.borderColor = ORANGERED.CGColor;
    }else {
        sender.text = [sender.text substringToIndex:11];
    }
}
//- (IBAction)codeEditingChanged:(UITextField *)sender {
//    if (sender.text.length>6) {
//        sender.text = [sender.text substringToIndex:6];
//    }
//}
//- (IBAction)pwdEditingChanged:(UITextField *)sender {
//    if (sender.text.length>15) {
//        sender.text = [sender.text substringToIndex:15];
//    }
//}
- (IBAction)checkButtonClick:(UIButton *)sender {
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
            sender.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        }
    }];
//    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
//        [YHHud showWithMessage:@"无效手机号"];
//    }else{
//        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
//            if (!error) {
//                _countDown = COUNTDOWN;
//                sender.enabled = NO;
//                sender.backgroundColor = [UIColor lightGrayColor];
//                [sender setTitle:[NSString stringWithFormat:@"%ds",_countDown] forState:UIControlStateNormal];
//                _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                    _countDown--;
//                    [sender setTitle:[NSString stringWithFormat:@"%ds",_countDown] forState:UIControlStateNormal];
//                    if (_countDown == 0) {
//                        [timer invalidate];
//                        sender.enabled = YES;
//                        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
//                        sender.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
//                    }
//                }];
//            } else {
//                NSLog(@"错误信息：%@",error);
//                [YHHud showWithMessage:@"验证码错误"];
//            }
//        }];
//    }
    //    {
    //        "phoneNum":"13300001111",  #手机号
    //        "stype":1,                 #类型  1注册 2登录 3找回密码
    //        "deviceNum":"123456",      #设备码（选填）
    //    }
    NSString *phoneNum = _phoneTxt.text;
    NSDictionary *jsonDic = @{
                                      @"phoneNum" :phoneNum,             // #用户名
                                      @"stype":@"3",               //    #类型  1注册 2登录 3找回密码
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
//- (IBAction)showPwd:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    _pwdText.secureTextEntry = !sender.selected;
//}
- (IBAction)submitButton:(UIButton *)sender {
//    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
//        [YHHud showWithMessage:@"请输入有效11位手机号"];
//    }else if (REGEX(CHECHCODE_RE, _idCodeText.text)==NO){
//        [YHHud showWithMessage:@"验证码错误"];
//    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
//        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
//    }else {
//        [SMSSDK commitVerificationCode:_idCodeText.text phoneNumber:_phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//            if (!error) {
//                NSLog(@"%@",error);
//                NSDictionary *dic = @{@"userName":_phoneText.text,@"password":_pwdText.text};
//                [YHWebRequest YHWebRequestForPOST:FORGETPWD parameters:dic success:^(NSDictionary *json) {
//                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                        [YHHud showWithSuccess:@"重置密码成功"];
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [self.navigationController popViewControllerAnimated:YES];
//                        });
//                    }else if ([json[@"code"] isEqualToString:@"UPDATEERR"]){
//                        [YHHud showWithMessage:@"修改失败"];
//                    }else if([json[@"code"] isEqualToString:@"USERR"]){
//                        [YHHud showWithMessage:@"手机号错误"];
//                    }else{
//                         [YHHud showWithMessage:@"重置密码失败"];
//                    }
//                } failure:^(NSError * _Nonnull error) {
//                    [YHHud showWithMessage:@"数据请求失败"];
//                }];
//            }else{
//                [YHHud showWithMessage:@"验证码错误"];
//            }
//        }];
//    }
    
//    {
//        phoneNum:"13300001111",    #用户手机号
//        password:"",               #新密码
//        verifyCode:"",             #短信验证码
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSString *password = _pwdTxt.text;
    NSString *verifyCode = _checkCodeTxt.text;
    NSDictionary *jsonDic = @{
                                        @"phoneNum" :phoneNum,             // #用户手机号
                                        @"password":password,               //    #新密码
                                        @"verifyCode":verifyCode             //     #短信验证码
                                      };
    [YHWebRequest YHWebRequestForPOST:kSetPwd parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            [YHHud showWithSuccess:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_countDownTimer invalidate];
}
@end
