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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *showPwdButtonCollection;

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
    for (UIButton *item in _showPwdButtonCollection) {
        [item dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
        [item dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
        [item dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
        [item dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
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
- (IBAction)showPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    UITextField *text = [_textFieldCollection objectAtIndex:sender.tag];
    text.secureTextEntry = !sender.selected;
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    if ([_oldPwdText.text isEqualToString:USER_PWD] == NO) {
//        ALERT_SHOW();
        [YHHud showWithMessage:@"你输入的原密码不正确"];
    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
//        ALERT_SHOW();
        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
    }else if ([_surePwdText.text isEqualToString:_pwdText.text] == NO){
//        ALERT_SHOW();
        [YHHud showWithMessage:@"两次密码输入不一致"];
    }else{
//        NSLog();
        [YHHud showWithSuccess:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}
@end
