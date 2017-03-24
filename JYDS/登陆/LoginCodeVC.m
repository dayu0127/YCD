//
//  LoginCodeVC.m
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "LoginCodeVC.h"
#import <UMSocialCore/UMSocialCore.h>
@interface LoginCodeVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 7.5f;
    _loginButton.layer.borderWidth = 1.0f;
    _loginButton.layer.borderColor = GRAYCOLOR.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)phoneEditingChanged:(UITextField *)sender {
    if (sender.text.length==0) {
        _loginButton.enabled = NO;
        [_loginButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        _loginButton.layer.borderColor = GRAYCOLOR.CGColor;
    }else if(sender.text.length>0&&sender.text.length<=11){
        _loginButton.enabled = YES;
        [_loginButton setTitleColor:ORANGERED forState:UIControlStateNormal];
        _loginButton.layer.borderColor = ORANGERED.CGColor;
    }else {
        sender.text = [sender.text substringToIndex:11];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pwdLoginClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)qqLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}
- (IBAction)wxLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

@end
