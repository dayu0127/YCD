//
//  ForgetPwdVC.m
//  YCD
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "ForgetPwdVC.h"
#define ID_CODE @"1234"
@interface ForgetPwdVC ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitButton:(UIButton *)sender;
@property (strong,nonatomic) UITextField *phoneText;
@property (strong,nonatomic) UITextField *idCodeText;
@property (strong,nonatomic) UITextField *pwdText;
@property (strong,nonatomic)NSTimer *countDownTimer;
@property (assign,nonatomic)int countDown;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@end

@implementation ForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],N_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITextField *item in _textFieldCollection) {
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UIView *line in _lineCollection) {
        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    }
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
    _submitButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _phoneText = [_textFieldCollection objectAtIndex:0];
    _idCodeText = [_textFieldCollection objectAtIndex:1];
    _pwdText = [_textFieldCollection objectAtIndex:2];
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
//        ALERT_SHOW();
        [YHHud showWithMessage:@"无效手机号"];
    }else{
//        ALERT_SHOW();
//        [YHHud showWithMessage:@"获取验证码"];
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
    }
}
- (IBAction)showPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    _pwdText.secureTextEntry = !sender.selected;
}
- (IBAction)submitButton:(UIButton *)sender {
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
//        ALERT_SHOW();
        [YHHud showWithMessage:@"请输入有效11位手机号"];
    }else if ([_idCodeText.text isEqualToString:ID_CODE]==NO){
//        ALERT_SHOW();
        [YHHud showWithMessage:@"验证码不正确"];
    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
//        ALERT_SHOW();
        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
    }else {
//        NSLog();
        [YHHud showWithSuccess:@"设置密码成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_countDownTimer invalidate];
}
@end
