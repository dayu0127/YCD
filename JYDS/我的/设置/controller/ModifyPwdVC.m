//
//  ModifyPwdVC.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ModifyPwdVC.h"

@interface ModifyPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *reNewPwdTxt;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation ModifyPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 7.5f;
    _sureButton.layer.borderWidth = 1.0f;
    _sureButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
}
- (IBAction)backClick:(id)sender {
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
- (IBAction)sureButtonClick:(UIButton *)sender {
//    {
//        phoneNum:"13300001111",    #用户手机号
//        token: "zzzzzz",           #令牌
//        password:"",               #旧密码
//        newPassword:""             #新密码
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSString *oldPwd = _oldPwdTxt.text;
    NSString *newPwd = _pwdTxt.text;
    NSDictionary *jsonDic = @{@"phoneNum":phoneNum,  //  #用户手机号
                                          @"token":self.token,     //      #令牌
                                          @"password":oldPwd,      //         #旧密码
                                          @"newPassword":newPwd};     //        #新密码
    NSLog(@"%@",jsonDic);
    [YHWebRequest YHWebRequestForPOST:kUpdatePwd parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            [YHHud showWithMessage:@"修改成功,请重新登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //清空token
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tolen"];
                //清空个人信息
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                //改变登录状态
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                //跳转到登录页面
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
                [app.window setRootViewController:loginVC];
                [app.window makeKeyWindow];
            });
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
