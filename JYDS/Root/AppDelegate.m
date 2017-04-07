//
//  AppDelegate.m
//  JYDS
//
//  Created by dayu on 2016/11/21.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "AppDelegate.h"
#import "UserGuideViewController.h"
#import "LoginNC.h"
#import "RootTabBarController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <SMS_SDK/SMSSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "WXApiManager.h"
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>


@interface AppDelegate ()
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _isReachable = YES;
    //监测网络状态
    [self checkNetStatus];
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
        //不是第一次启动
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == YES) { //登录了
//            [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"root"];
//        }else{ //未登录
//            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
//        }
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)checkNetStatus{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [YHHud dismiss];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                _isReachable = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _isReachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _isReachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _isReachable = YES;
            default:
                break;
        }
    }];
}

#pragma mark 初始化设置
- (void)initSettings{
    //取消返回按钮文字
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [buttonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    //设置
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [UITableView appearance].separatorColor = SEPCOLOR;
    //判断是否加载夜间模式
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNightMode"]==YES) {
        [[DKNightVersionManager sharedManager] nightFalling];
    }else{
        [[DKNightVersionManager sharedManager] dawnComing];
    }
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
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1292322940"  appSecret:@"c1ad238284f47072b0caaf27d4d3afb3" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //SMSSDK集成短信验证码
    [SMSSDK registerApp:@"1a0a96a7aca8e" withSecret:@"84dcd3028b078eb4ecbe9bed5c669dec"];
    [SMSSDK enableAppContactFriends:NO];
    
    //微信支付注册APPID
    [WXApi registerApp:@"wx7658d0735b233185"];
}
- (void)getBannerInfo{
    [YHWebRequest YHWebRequestForPOST:kBanner parameters:nil success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:@"banner"];
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
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSDictionary *dic = [NSDictionary dictionary];
//                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {//订单支付成功
//                    dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"result":resultDic[@"result"],@"code":resultDic[@"resultStatus"]};
//                }else{
//                    dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"out_trade_no":[YHSingleton shareSingleton].ali_out_trade_no,@"code":resultDic[@"resultStatus"]};
//                }
//                [YHWebRequest YHWebRequestForPOST:ALICHECK parameters:dic success:^(NSDictionary *json) {
//                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                        if ([json[@"payType"] isEqualToString:@"SUCCESS"]) {
//                            [YHHud showWithSuccess:@"支付成功"];
//                            [self updateStudyBean];
//                        }else{
//                            [YHHud showWithMessage:@"支付失败"];
//                        }
//                    }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                        [YHHud showWithMessage:@"服务器出错了，请稍后重试"];
//                    }else{
//                        [YHHud showWithMessage:@"支付失败"];
//                    }
//                } failure:^(NSError * _Nonnull error) {
//                    [YHHud showWithMessage:@"数据请求失败"];
//                }];
//            }];
        }
    }else{
        // 微信SDK的回调
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}
#pragma mark 更新用户剩余和充值的学习豆
- (void)updateStudyBean{
//    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            [YHSingleton shareSingleton].userInfo.studyBean = [NSString stringWithFormat:@"%@",json[@"data"][@"restBean"]];
//            [YHSingleton shareSingleton].userInfo.rechargeBean = [NSString stringWithFormat:@"%@",json[@"data"][@"rechargeBean"]];
//            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateStudyBean" object:nil];
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"数据异常"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [YHHud showWithMessage:@"数据请求失败"];
//    }];
}
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [UMSocialSnsService  applicationDidBecomeActive];
//}
@end
