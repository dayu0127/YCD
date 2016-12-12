//
//  BindingNewPhoneVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BindingNewPhoneVC.h"
#define ID_CODE @"1234"
#define USER_PWD @"m12345"
@interface BindingNewPhoneVC ()


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)sureButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (strong,nonatomic) UITextField *phoneText;
@property (strong,nonatomic) UITextField *codeText;
@property (strong,nonatomic) UITextField *pwdText;
@end

@implementation BindingNewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _phoneText = [_textFieldCollection objectAtIndex:0];
    _codeText = [_textFieldCollection objectAtIndex:1];
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
- (IBAction)checkButtonClick:(UIButton *)sender {
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
        ALERT_SHOW(@"无效手机号");
    }else{
        ALERT_SHOW(@"获取验证码");
    }
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
        ALERT_SHOW(@"请输入11位有效手机号");
    }else if ([_codeText.text isEqualToString:ID_CODE] == NO){
        ALERT_SHOW(@"验证码不正确");
    }else if ([_pwdText.text isEqualToString:USER_PWD] == NO){
        ALERT_SHOW(@"密码不正确");
    }else{
        NSLog(@"绑定成功！");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
