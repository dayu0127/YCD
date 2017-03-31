//
//  AccountSetVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "AccountSetVC.h"
#import "SetCell.h"
#import "AccountSetCell.h"
#import <UMSocialCore/UMSocialCore.h>
@interface AccountSetVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccountSetCell" bundle:nil] forCellReuseIdentifier:@"AccountSetCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
        cell.title1.text = @"手机号码";
        cell.title2.font = [UIFont systemFontOfSize:12.0f];
        cell.title2.text = @"13712345678";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        AccountSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSetCell" forIndexPath:indexPath];
        return cell;
    }else{
        AccountSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSetCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"QQ账号";
        return cell;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        {
//            "phoneNum":"13300001111",       #用户手机号
//            "token: "zzzzzz",               #令牌
//            "associatedWx":"dfdsfsdfsdf",   #第三方绑定的uid 唯一标识
//            "country":"",                   #国家（选填）
//            "province":"",                  #省市（选填）
//            "city":"",                      #城市（选填）
//            "genter":""                     #性别 1男 0女  （选填）
//            
//        }
        NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSString *associatedWx = [YHSingleton shareSingleton].userInfo.associatedWx;
        NSDictionary *jsonDic = @{
                                          @"phoneNum":phoneNum,      // #用户手机号
                                          @"token":token,            //   #令牌
                                          @"associatedWx":associatedWx  // #第三方绑定的uid 唯一标识
                                          };
        [YHWebRequest YHWebRequestForPOST:kBindingWX parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                [YHHud showWithSuccess:@"绑定成功"];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else if (indexPath.row == 2) {
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
                
                NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
                NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                NSString *associatedQq = resp.uid;
                NSDictionary *jsonDic = @{
                                          @"phoneNum":phoneNum,      // #用户手机号
                                          @"token":token,            //   #令牌
                                          @"associatedQq":associatedQq  // #第三方绑定的uid 唯一标识
                                          };
                [YHWebRequest YHWebRequestForPOST:kBindingQQ parameters:jsonDic success:^(NSDictionary *json) {
                    if ([json[@"code"] integerValue] == 200) {
                        [YHHud showWithSuccess:@"绑定成功"];
                    }
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }
        }];

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

@end
