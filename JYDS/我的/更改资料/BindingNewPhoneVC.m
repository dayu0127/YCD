//
//  BindingNewPhoneVC.m
//  JYDS
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BindingNewPhoneVC.h"
#import <SMS_SDK/SMSSDK.h>

@interface BindingNewPhoneVC ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (strong,nonatomic) UITextField *phoneText;
@property (strong,nonatomic) UITextField *codeText;
@property (strong,nonatomic) UITextField *pwdText;
@property (strong,nonatomic)NSTimer *countDownTimer;
@property (assign,nonatomic)int countDown;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@end

@implementation BindingNewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
    _phoneText = [_textFieldCollection objectAtIndex:0];
    _codeText = [_textFieldCollection objectAtIndex:1];
    _pwdText = [_textFieldCollection objectAtIndex:2];
}
- (void)nightModeConfiguration{
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITextField *item in _textFieldCollection) {
        //KVC实现改变placeHolder的字体色
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UIView *line in _lineCollection) {
        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    }
    _sureButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if(sender.text.length < 11){
        _checkButton.enabled = NO;
        _checkButton.backgroundColor = [UIColor lightGrayColor];
    }else if(sender.text.length == 11){
        _checkButton.enabled = YES;
        _checkButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    }else{
        sender.text = [sender.text substringToIndex:11];
    }
}
- (IBAction)codeEditingChanged:(UITextField *)sender {
    if (sender.text.length>6) {
        sender.text = [sender.text substringToIndex:6];
    }
}
- (IBAction)pwdEditingChanged:(UITextField *)sender {
    if (sender.text.length>15) {
        sender.text = [sender.text substringToIndex:15];
    }
}
- (IBAction)checkButtonClick:(UIButton *)sender {
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
        [YHHud showWithMessage:@"无效手机号"];
    }else{
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
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
            } else {
                NSLog(@"错误信息：%@",error);
                [YHHud showWithMessage:@"验证码错误"];
            }
        }];
    }
}
- (IBAction)showPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    _pwdText.secureTextEntry = !sender.selected;
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
        [YHHud showWithMessage:@"请输入11位有效手机号"];
    }else if (REGEX(CHECHCODE_RE, _codeText.text) == NO){
        [YHHud showWithMessage:@"验证码错误"];
    }else if (REGEX(PWD_RE, _pwdText.text) == NO){
        [YHHud showWithMessage:@"密码不正确"];
    }else{
        [SMSSDK commitVerificationCode:_codeText.text phoneNumber:_phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            if (!error) {
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"oldMobile":[YHSingleton shareSingleton].userInfo.userName,@"newMobile":_phoneText.text,@"password":_pwdText.text};
                [YHWebRequest YHWebRequestForPOST:BNEWPHONE parameters:dic success:^(NSDictionary *json) {
                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                        [YHHud showWithSuccess:@"绑定成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //更新用户信息
                            [YHSingleton shareSingleton].userInfo.userName = _phoneText.text;
                            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePhoneNum" object:nil userInfo:@{@"phoneNum":_phoneText.text}];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }else if([json[@"code"] isEqualToString:@"ERROR"]){
                        [YHHud showWithMessage:@"服务器错误"];
                    }else{
                        [YHHud showWithMessage:@"绑定失败"];
                    }
                }];
            }else{
                NSLog(@"%@",error);
                [YHHud showWithMessage:@"验证码错误"];
            }
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_countDownTimer invalidate];
}
@end
