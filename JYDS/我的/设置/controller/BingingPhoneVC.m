//
//  BingingPhoneVC.m
//  JYDS
//
//  Created by liyu on 2017/4/1.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "BingingPhoneVC.h"

@interface BingingPhoneVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

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
#pragma mark 获取验证码
- (IBAction)getCheckCode:(id)sender {
    NSString *phoneNum = _phoneTxt.text;
    NSDictionary *jsonDic = @{@"phoneNum" :phoneNum,             // #用户名
                              @"stype":@"1",               //    #类型  1注册 2登录 3找回密码
                              @"deviceNum":DEVICEID             //     #设备码（选填）
                              };
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSLog(@"绑定成功");
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
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
    NSString *password = _pwdTxt.text;
    NSString *verifyCode = _checkCodeTxt.text;
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSString *bindingType = @"";
    NSString *associatedWx = [YHSingleton shareSingleton].userInfo.associatedWx;
    NSString *associatedQq = [YHSingleton shareSingleton].userInfo.associatedQq;
    if (![associatedQq isEqualToString:@""]) {
        bindingType = @"1";
    }else if (![associatedWx isEqualToString:@""]){
        bindingType = @"2";
    }
    NSDictionary *jsonDic = @{  @"phoneNum":phoneNum,       //#用户手机号
                                            @"password":password,           //#密码            与登陆类型一致
                                            @"verifyCode":verifyCode,           //#短信验证码      与登陆类型一致
                                            @"bindingType":bindingType,         //#当前第三方登陆的类型 1qq 2weixin
                                            @"associatedWx":associatedWx,       //#第三方绑定的uid 唯一标识 (选填)
                                            @"associatedQq":associatedQq};      //#第三方绑定的uid 唯一标识 (选填)     qq微信必须填一个不能两个都不填！
    [YHWebRequest YHWebRequestForPOST:kSendCheckCode parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSLog(@"绑定成功");
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
