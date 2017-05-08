//
//  ModifyPwdVC.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ModifyPwdVC.h"
#import <UIImageView+WebCache.h>
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
- (IBAction)pwdEditingChanged:(UITextField *)sender {
    if (sender.text.length>15) {
        sender.text = [sender.text substringToIndex:15];
    }
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    NSString *newPwd = [_pwdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newPwd isEqualToString:@""]&&newPwd.length<6) {
        [YHHud showWithMessage:@"密码长度不能低于6位"];
    }else if(![_reNewPwdTxt.text isEqualToString:_pwdTxt.text]){
        [YHHud showWithMessage:@"两次密码输入不一致"];
    }else{
    //    {
    //        phoneNum:"13300001111",    #用户手机号
    //        token: "zzzzzz",           #令牌
    //        password:"",               #旧密码
    //        newPassword:""             #新密码
    //    }
        NSString *oldPwd = _oldPwdTxt.text;
        NSDictionary *jsonDic = @{
            @"phoneNum":self.phoneNum,  //  #用户手机号
            @"token":self.token,     //      #令牌
            @"password":oldPwd,      //         #旧密码
            @"newPassword":newPwd     //        #新密码
        };
        [YHWebRequest YHWebRequestForPOST:kUpdatePwd parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                [YHHud showWithMessage:@"修改成功,请重新登录"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //清空banner
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"banner"];
                    //清空token
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tolen"];
                    //清空个人信息
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                    //清除个人点赞
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"likesDic"];
                    //清除缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                    [[SDImageCache sharedImageCache] clearMemory];//可有可无
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
}
@end
