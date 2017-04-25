//
//  AppDelegate.m
//  JYDS
//
//  Created by dayu on 2016/11/21.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "AppDelegate.h"
#import "UserGuideViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "iflyMSC/IFlyMSC.h"

@interface AppDelegate ()
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化设置
    [self getBannerInfo];
    [self initSettings];
    //设置根视图控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动,使用UserGuideViewController (用户引导页面) 作为根视图
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"userGuide"];
    } else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"root"];
    }
    [self.window makeKeyAndVisible];
    return YES;
}
//监测网络状态
//- (void)checkNetStatus{
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        [YHHud dismiss];
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                _isReachable = NO;
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                _isReachable = NO;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                _isReachable = YES;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                _isReachable = YES;
//            default:
//                break;
//        }
//    }];
//}

#pragma mark 初始化设置
- (void)initSettings{
    //取消返回按钮文字
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [buttonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    //设置
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [UITableView appearance].separatorColor = SEPCOLOR;
    //判断是否加载夜间模式
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNightMode"]==YES) {
//        [[DKNightVersionManager sharedManager] nightFalling];
//    }else{
//        [[DKNightVersionManager sharedManager] dawnComing];
//    }
    //分享
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58524346f43e482aaa0012d6"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);

    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7658d0735b233185" appSecret:@"07f165e769707ce2d10955666edbeb1c" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105811937"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1292322940"  appSecret:@"c1ad238284f47072b0caaf27d4d3afb3" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //微信支付注册APPID
    [WXApi registerApp:@"wx7658d0735b233185"];
    
    //科大讯飞
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"58e78076"];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
- (void)getBannerInfo{
    //获取首页内容
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum!=nil ? [YHSingleton shareSingleton].userInfo.phoneNum : @"";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]!=nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] : @"";
    NSDictionary *jsonDic = @{
        @"userPhone":phoneNum,      //  #用户手机号
        @"token":token        //    #用户登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kBanner parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:@"banner"];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    }failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 设置系统回调(支持所有iOS系统)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 支付宝SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //支付宝验签
                NSDictionary *jsonDic = @{
                    @"userPhone":[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"][@"phoneNum"],   // #用户手机号
                    @"code":resultDic[@"resultStatus"],        //    #支付宝支付状态码
                    @"out_trade_no":[YHSingleton shareSingleton].ali_out_trade_no, //   #商户订单号（选填，与transaction_id二选一）
                    @"result":resultDic[@"result"],      //    #支付宝返回的订单信息
                    @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]      //   #登陆凭证
                };
                [YHWebRequest YHWebRequestForPOST:kAlipaySignCheck parameters:jsonDic success:^(NSDictionary *json) {
                    if ([json[@"code"] integerValue] == 200) {
                        if ([[YHSingleton shareSingleton].payType isEqualToString:@"0"]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWordSubStatus" object:nil];
                        }else if ([[YHSingleton shareSingleton].payType isEqualToString:@"1"]){
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMemorySubStatus" object:nil];
                        }
                        [YHHud showPaySuccessOrFailed:@"success"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [YHHud dismiss];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
                        });
                    }else{
                        NSLog(@"%@",json[@"code"]);
//                        [YHHud showWithMessage:json[@"message"]];
                        [YHHud showPaySuccessOrFailed:@"failed"];
                    }
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }];
        }
    }else{
        // 微信SDK的回调
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}
@end
