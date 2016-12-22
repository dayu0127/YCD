//
//  LoginVC.m
//  YCD
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "LoginVC.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"

@interface LoginVC ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@property (strong,nonatomic) UITextField *phoneText;
@property (strong,nonatomic) UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],N_BG,RED);
    for (UITextField *item in _textFieldCollection) {
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UIView *line in _lineCollection) {
        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    }
    _loginButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    for (UIButton *item in _buttonCollection) {
        [item dk_setTitleColorPicker:DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED) forState:UIControlStateNormal];
    }
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
    _phoneText = [_textFieldCollection objectAtIndex:0];
    _pwdText = [_textFieldCollection objectAtIndex:1];
}
- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
}
- (IBAction)pwdEditingChanged:(UITextField *)sender {
    if (sender.text.length > 15) {
        sender.text = [sender.text substringToIndex:15];
    }
}
- (IBAction)showPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    _pwdText.secureTextEntry = !sender.selected;
}
- (IBAction)loginButtonClick:(UIButton *)sender {
//    UITextField *textField = [_textFieldCollection objectAtIndex:0];
//    UITextView *textField1 = [_textFieldCollection objectAtIndex:1];
//    NSString *userName = textField.text;
//    NSString *password = textField1.text;
//    if ([userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
//        NSLog(@"您还没输入手机号和密码呢^_^");
//    }else{
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",password,@"password",nil];
//        [YHWebRequest YHWebRequestForPOST:LOGIN parameters:dic success:^(id  _Nonnull json) {
////                    NSLog(@"%@",json);
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"%@",dic);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"网络异常 - T_T%@", error);
//        }];
//    }
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
//        ALERT_SHOW();
        [YHHud showWithMessage:@"请输入有效的11位手机号"];
    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
//        ALERT_SHOW();
        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
    }else{
        //--实现登录--
        //设置用户昵称和手机号
        [[NSUserDefaults standardUserDefaults] setObject:@"大雨" forKey:@"nickName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"13333333333" forKey:@"phoneNum"];
        [YHHud showWithSuccess:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
            [app.window setRootViewController:rootTBC];
            [app.window makeKeyWindow];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
        });
    }
}
@end
