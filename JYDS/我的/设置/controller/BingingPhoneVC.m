//
//  BingingPhoneVC.m
//  JYDS
//
//  Created by liyu on 2017/4/1.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "BingingPhoneVC.h"
#import <UIImageView+WebCache.h>
@interface BingingPhoneVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTxt;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong,nonatomic) NSTimer *countDownTimer;
@property (assign,nonatomic)int countDown;
@end

@implementation BingingPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 7.5f;
    _sureButton.layer.borderWidth = 1.0f;
    _sureButton.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark 获取验证码
- (IBAction)getCheckCode:(UIButton *)sender {
    //验证码按钮倒计时
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
            sender.backgroundColor = ORANGERED;
        }
    }];
    NSString *phoneNum = _phoneTxt.text;
    NSDictionary *jsonDic = @{
        @"phoneNum" :phoneNum,             // #用户名
        @"stype":@"2",               //    #类型  1注册 2登录 3找回密码
        @"deviceNum":DEVICEID             //     #设备码（选填）
    };
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        NSLog(@"%@",json[@"code"]);
        [YHHud showWithMessage:json[@"message"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 确定绑定
- (IBAction)sureButtonClick:(id)sender {
//    {
//        "phoneNum":"13300001111",       #用户手机号
//        "password":"13300001111",       #密码            与登陆类型一致
//        "verifyCode":"",                #短信验证码      与登陆类型一致
//        "bindingType":"",               #当前第三方登陆的类型 1qq 2weixin
//        "associatedWx":"dfdsfsdfsdf",   #第三方绑定的uid 唯一标识 (选填)
//        "associatedQq":"dfdsfsdfsdf",   #第三方绑定的uid 唯一标识 (选填)     qq微信必须填一个不能两个都不填！
//        "country":"",                   #国家（选填）
//        "province":"",                  #省市（选填）
//        "city":"",                      #城市（选填）
//        "genter":""                     #性别 1男 0女  （选填）
//        
//    }
    NSString *phoneNum = _phoneTxt.text;
    NSString *verifyCode = _checkCodeTxt.text;
    NSString *bindingType;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] isEqualToString:@"qq"]) {
        bindingType = @"1";
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] isEqualToString:@"wx"]){
        bindingType = @"2";
    }
    NSString *associatedWx = self.associatedWx!=nil ? self.associatedWx : @"";
    NSString *associatedQq = self.associatedQq!=nil ? self.associatedQq : @"";
    NSDictionary *jsonDic = @{
        @"phoneNum":phoneNum,       //#用户手机号
        @"verifyCode":verifyCode,           //#短信验证码      与登陆类型一致
        @"bindingType":bindingType,         //#当前第三方登陆的类型 1qq 2weixin
        @"associatedWx":associatedWx,       //#第三方绑定的uid 唯一标识 (选填)
        @"associatedQq":associatedQq      //#第三方绑定的uid 唯一标识 (选填)     qq微信必须填一个不能两个都不填！
    };
    [YHWebRequest YHWebRequestForPOST:kBindingPhone parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
//            NSLog(@"%@",[NSDictionary dictionaryWithJsonString:json[@"data"]]);
//            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
//            //保存token
//            [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"token"] forKey:@"token"];
//            //保存用户信息
//            [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"user"] forKey:@"userInfo"];
//            [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:dataDic[@"user"]];
//            //改变我的页面，显示头像,昵称和手机号
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeaderView" object:nil];
//            [YHHud showWithSuccess:@"绑定成功"];
//            //改变手机绑定状态显示
//            [_delegate updatePhoneBingingState:_phoneTxt.text];
//            [self.navigationController popViewControllerAnimated:YES];
            [YHHud showWithMessage:@"绑定成功,请重新登录"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
