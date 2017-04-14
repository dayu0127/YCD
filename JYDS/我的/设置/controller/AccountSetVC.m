//
//  AccountSetVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "AccountSetVC.h"

#import "SetCell0.h"
#import <UMSocialCore/UMSocialCore.h>
@interface AccountSetVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell0" bundle:nil] forCellReuseIdentifier:@"SetCell0"];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell0" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel0.text = @"修改密码";
        [cell setCellWithString:@""];
        cell.bingingLabel.alpha = 0;
    }else if (indexPath.row == 1) {
        cell.titleLabel0.text = @"手机号码";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.phoneNum];
    }else if (indexPath.row == 1){
        cell.titleLabel0.text = @"微信账号";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.associatedWx];
    }else{
        cell.titleLabel0.text = @"QQ账号";
        [cell setCellWithString:[YHSingleton shareSingleton].userInfo.associatedQq];
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"toModifyPwdVC" sender:self];
    }else if (indexPath.row == 1) {//手机号绑定
        if ([[YHSingleton shareSingleton].userInfo.phoneNum isEqualToString:@""]) {
            [self performSegueWithIdentifier:@"toBingingPhone" sender:self];
        }
    }else if (indexPath.row == 2) {//微信绑定
        if ([[YHSingleton shareSingleton].userInfo.associatedWx isEqualToString:@""]) {
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    //                {
                    //                    "phoneNum":"13300001111",       #用户手机号
                    //                    "token: "zzzzzz",               #令牌
                    //                    "associatedWx":"dfdsfsdfsdf",   #第三方绑定的uid 唯一标识
                    //                    "country":"",                   #国家（选填）
                    //                    "province":"",                  #省市（选填）
                    //                    "city":"",                      #城市（选填）
                    //                    "genter":""                     #性别 1男 0女  （选填）
                    //
                    //                }
                    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
                    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                    NSString *associatedWx = resp.uid;
                    NSDictionary *jsonDic = @{@"phoneNum":phoneNum,      // #用户手机号
                                                          @"token":token,            //   #令牌
                                                         @"associatedWx":associatedWx};  // #第三方绑定的uid 唯一标识
                    NSLog(@"%@",jsonDic);
                    [YHWebRequest YHWebRequestForPOST:kBindingWX parameters:jsonDic success:^(NSDictionary *json) {
                        if ([json[@"code"] integerValue] == 200) {
                            NSLog(@"%@",json);
                            [YHHud showWithSuccess:@"绑定成功"];
                            [YHSingleton shareSingleton].userInfo.associatedWx = associatedWx;
                            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }else{
                            NSLog(@"%@",json[@"code"]);
                            NSLog(@"%@",json[@"message"]);
                        }
                    } failure:^(NSError * _Nonnull error) {
                        NSLog(@"%@",error);
                    }];
                }
            }];
        }
    }else {//QQ绑定
//        {
//            "phoneNum":"13300001111",       #用户手机号
//            "token: "zzzzzz",               #令牌
//            "associatedQq":"dfdsfsdfsdf",   #第三方绑定的uid 唯一标识
//            "country":"",                   #国家（选填）
//            "province":"",                  #省市（选填）
//            "city":"",                      #城市（选填）
//            "genter":""                     #性别 1男 0女  （选填）
//            
//        }
        if ([[YHSingleton shareSingleton].userInfo.associatedQq isEqualToString:@""]) {
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
                    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                    NSString *associatedQq = resp.uid;
                    NSDictionary *jsonDic = @{@"phoneNum":phoneNum,      // #用户手机号
                                              @"token":token,            //   #令牌
                                              @"associatedQq":associatedQq};  // #第三方绑定的uid 唯一标识
                    [YHWebRequest YHWebRequestForPOST:kBindingQQ parameters:jsonDic success:^(NSDictionary *json) {
                        NSLog(@"%@",json);
                        if ([json[@"code"] integerValue] == 200) {
                            [YHHud showWithMessage:@"绑定成功"];
                            [YHSingleton shareSingleton].userInfo.associatedQq = associatedQq;
                            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }else{
                            NSLog(@"%@",json[@"code"]);
                            NSLog(@"%@",json[@"message"]);
                        }
                    } failure:^(NSError * _Nonnull error) {
                        NSLog(@"%@",error);
                    }];
                }
            }];
        }
    }
}
#pragma mark 退出当前账号
- (IBAction)logoutClick:(id)sender {
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
