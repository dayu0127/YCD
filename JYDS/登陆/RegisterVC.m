//
//  RegisterVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "RegisterVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "UserAgreementVC.h"
@interface RegisterVC ()<UITextFieldDelegate>
//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
//@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
//@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
//@property (strong,nonatomic)UITextField *phoneText;
//@property (strong,nonatomic)UITextField *idCodeText;
//@property (strong,nonatomic)UITextField *pwdText;
//@property (strong,nonatomic)UITextField *studyCodeText;
//@property (strong,nonatomic)NSTimer *countDownTimer;
//@property (assign,nonatomic)int countDown;
//@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
//@property (strong,nonatomic) JCAlertView *alertView;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _registerButton.layer.masksToBounds = YES;
    _registerButton.layer.cornerRadius = 7.5f;
    _registerButton.layer.borderWidth = 1.0f;
    _registerButton.layer.borderColor = GRAYCOLOR.CGColor;
//    [self nightModeConfiguration];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
//    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
//    _phoneText = [_textFieldCollection objectAtIndex:0];
//    _idCodeText = [_textFieldCollection objectAtIndex:1];
//    _pwdText = [_textFieldCollection objectAtIndex:2];
//    _studyCodeText = [_textFieldCollection objectAtIndex:3];
}
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
//    _registerButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//}
#pragma mark 监听是否输入11位手机号，改变验证码按钮状态
- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length==0) {
        _registerButton.enabled = NO;
        [_registerButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        _registerButton.layer.borderColor = GRAYCOLOR.CGColor;
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
//#pragma mark 限制密码长度不能超过15位
//- (IBAction)pwdEditingChanged:(UITextField *)sender {
//    if (sender.text.length>15) {
//        sender.text = [sender.text substringToIndex:15];
//    }
//}
#pragma mark 验证码按钮点击
- (IBAction)checkButtonClick:(UIButton *)sender {
//    运营商号段如下：
//    中国移动号码：134、135、136、137、138、139、147（无线上网卡）、150、151、152、157、158、159、182、183、187、188、178
//    中国联通号码：130、131、132、145（无线上网卡）、155、156、185（iPhone5上市后开放）、186、176（4G号段）、175（2015年9月10日正式启用，暂只对北京、上海和广东投放办理）
//    中国电信号码：133、153、180、181、189、177、173、149
//    虚拟运营商：170、1718、1719
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
//        __block int timeout=10; //倒计时时间
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//        dispatch_source_set_event_handler(_timer, ^{
//            if(timeout<=0){ //倒计时结束，关闭
//                dispatch_source_cancel(_timer);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
//                    sender.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
//                    sender.userInteractionEnabled = YES;
//                });
//            }else{
//                int seconds = timeout % 59;
//                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    NSLog(@"____%@",strTime);
//                    [sender setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
//                    sender.backgroundColor = [UIColor grayColor];
//                    sender.userInteractionEnabled = NO;
//                });
//                timeout--;
//            }
//        });
//        dispatch_resume(_timer);
//    }
}
- (IBAction)registerButtonClick:(UIButton *)sender {
//    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
//        [YHHud showWithMessage:@"请输入有效11位手机号"];
//    }else if(REGEX(CHECHCODE_RE, _idCodeText.text)==NO){
//        [YHHud showWithMessage:@"验证码错误"];
//    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
//        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
//    }else {
//        [SMSSDK commitVerificationCode:_idCodeText.text phoneNumber:_phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//            if (!error) {
//                if ([_studyCodeText.text isEqualToString:@""]) {
//                    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 155) title:@"温馨提示" message:@"您输入的邀请码为空，确定注册？"];
//                    alertView.delegate = self;
//                    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
//                    [_alertView show];
//                }else{
//                    [self userRegister];
//                }
//            }else{
//                NSLog(@"%@",error);
//                [YHHud showWithMessage:[NSString stringWithFormat:@"%@",error.description]];
//            }
//        }];
//    }
}
- (void)userRegister{
//    NSDictionary *dic = @{@"userName":_phoneText.text,@"password":_pwdText.text,@"studyCode":_studyCodeText.text};
//    [YHWebRequest YHWebRequestForPOST:REGISTER parameters:dic success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            [YHHud showWithSuccess:@"注册成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [_delegate autoFillUserName:_phoneText.text];
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }else if([json[@"code"] isEqualToString:@"MOBILE_REPEAT"]){
//            [YHHud showWithMessage:@"该手机号已被注册"];
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"注册失败"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [YHHud showWithMessage:@"数据请求失败"];
//    }];
}
//- (void)buttonClickIndex:(NSInteger)buttonIndex{
//    [_alertView dismissWithCompletion:nil];
//    if (buttonIndex == 1) {
//        [self userRegister];
//    }
//}
//- (IBAction)checkBoxClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if (sender.selected == YES) {
//        _registerButton.enabled = YES;
//        _registerButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    }else{
//        _registerButton.enabled = NO;
//        _registerButton.backgroundColor = [UIColor lightGrayColor];
//    }
//}


//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [_countDownTimer invalidate];
//}
@end
