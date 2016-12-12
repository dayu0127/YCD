//
//  UpdatePwdVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "UpdatePwdVC.h"
#define USER_PWD @"m12345"
@interface UpdatePwdVC ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabelCollection;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)sureButtonClick:(UIButton *)sender;
@property (strong,nonatomic) UITextField *oldPwdText;
@property (strong,nonatomic) UITextField *pwdText;
@property (strong,nonatomic) UITextField *surePwdText;
@end
@implementation UpdatePwdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    for (UILabel *item in _titleLabelCollection) {
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
    _oldPwdText = [_textFieldCollection objectAtIndex:0];
    _pwdText = [_textFieldCollection objectAtIndex:1];
    _surePwdText = [_textFieldCollection objectAtIndex:2];
}
- (IBAction)pwdEditingChanged:(UITextField *)sender {
    if (sender.text.length>15) {
        sender.text = [sender.text substringToIndex:15];
    }
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    if ([_oldPwdText.text isEqualToString:USER_PWD] == NO) {
        ALERT_SHOW(@"你输入的原密码不正确");
    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
        ALERT_SHOW(@"请输入6~15位字母+数字组合的密码");
    }else if ([_surePwdText.text isEqualToString:_pwdText.text] == NO){
        ALERT_SHOW(@"两次密码输入不一致");
    }else{
        NSLog(@"修改成功");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
