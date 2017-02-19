//
//  LoginVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "LoginVC.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "RegisterVC.h"

@interface LoginVC ()<RegisterVCDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@property (strong,nonatomic) UITextField *phoneText;
@property (strong,nonatomic) UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateNormal];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateHighlighted];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"showPwd",@"showPwdN",@"") forState:UIControlStateSelected];
    [_showPwdButton dk_setImage:DKImagePickerWithNames(@"hidePwd",@"hidePwdN",@"") forState:UIControlStateDisabled];
    _phoneText = [_textFieldCollection objectAtIndex:0];
    _pwdText = [_textFieldCollection objectAtIndex:1];
    if ([YHSingleton shareSingleton].userInfo!=nil) {
        _phoneText.text = [YHSingleton shareSingleton].userInfo.userName;
    }
}
- (void)nightModeConfiguration{
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
    if (REGEX(PHONE_RE, _phoneText.text)==NO) {
        [YHHud showWithMessage:@"请输入有效的11位手机号"];
    }else if (REGEX(PWD_RE, _pwdText.text)==NO){
        [YHHud showWithMessage:@"请输入6~15位字母+数字组合的密码"];
    }else{
        //--实现登录--
        [YHHud showWithStatus:@"正在登陆"];
        NSDictionary *dic = @{@"userName":_phoneText.text,@"password":_pwdText.text};
        [YHWebRequest YHWebRequestForPOST:LOGIN parameters:dic success:^(NSDictionary *json) {
            [YHHud dismiss];
            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                //保存用户信息
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"] forKey:@"userInfo"];
                [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:json[@"data"]];
                [YHHud showWithSuccess:@"登陆成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
                    [app.window setRootViewController:rootTBC];
                    [app.window makeKeyWindow];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
                });
            }else if ([json[@"code"] isEqualToString:@"REPEAT_LOGIN"]){
                [YHHud showWithMessage:@"该账户已其他设备登陆"];
            }else if ([json[@"code"] isEqualToString:@"USAPWERR"]){
                [YHHud showWithMessage:@"用户名或密码错误"];
            }else{
                [YHHud showWithMessage:@"登录失败"];
            }
        }];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"register"]) {
        RegisterVC *registerVC = segue.destinationViewController;
        registerVC.delegate = self;
    }
}
- (void)autoFillUserName:(NSString *)userName{
    _phoneText.text = userName;
}
- (IBAction)logout:(id)sender {
    [YHWebRequest YHWebRequestForPOST:LOGOUT parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"type":@"1"} success:^(id  _Nonnull json) {}];
}
- (IBAction)removeAllSub:(id)sender {
    [YHWebRequest YHWebRequestForPOST:BOSSAPI(@"test") parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(id  _Nonnull json) {}];
}
- (IBAction)setZeroBean:(id)sender {
    [YHWebRequest YHWebRequestForPOST:BOSSAPI(@"test2") parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(id  _Nonnull json) {}];
}
- (IBAction)set999999Bean:(id)sender {
    [YHWebRequest YHWebRequestForPOST:BOSSAPI(@"test1") parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(id  _Nonnull json) {}];
}
@end
