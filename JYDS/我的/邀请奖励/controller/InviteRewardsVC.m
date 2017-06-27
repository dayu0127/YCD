//
//  InviteRewardsVC.m
//  JYDS
//
//  Created by 大雨 on 2017/4/2.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "InviteRewardsVC.h"
#import <WebKit/WebKit.h>
#import <UShareUI/UMSocialUIManager.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "DES3Util.h"
#import <WeiboSDK.h>
@interface InviteRewardsVC ()<WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *wkWebView;
@property (strong,nonatomic) UIView *bottomBgView;
@property (copy,nonatomic) NSString *shareTitle;
@property (copy,nonatomic) NSString *shareContent;
@property (copy,nonatomic) NSString *shareUrl;
@end

@implementation InviteRewardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [YHHud showWithStatus];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-129)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kInviteRewards]];
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
    _bottomBgView = [UIView new];
    _bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBgView];
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@65);
    }];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setTitle:@"邀请好友 领取优惠" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.backgroundColor = ORANGERED;
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.cornerRadius = 3.0f;
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [shareButton addTarget:self action:@selector(inviteShareClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBgView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bottomBgView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    _bottomBgView.alpha = 0;
}
#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    _bottomBgView.alpha = 1;
    [YHHud dismiss];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)inviteListClick:(UIButton *)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"toInviteList" sender:self];
    }
}
#pragma mark 设置分享内容(图文链接)
- (void)shareImageAndTextUrlToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享的网页地址对象
    NSString *title = _shareTitle;
    NSString *descr = _shareContent;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon-40"]];
    shareObject.webpageUrl = _shareUrl;
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
- (void)inviteShareClick:(UIButton *)sender {
    if ([WXApi isWXAppInstalled]==NO&&[QQApiInterface isQQInstalled]==NO&&[WeiboSDK isWeiboAppInstalled]==NO) {
        [YHHud showWithMessage:@"分享失败"];
    }else{
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if (token == nil && userInfo == nil) {
            [self returnToLogin];
        }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
            [self returnToBingingPhone];
        }else{
            NSDictionary *jsonDic = @{
                @"userPhone":self.phoneNum,
                @"token":self.token
            };
            [YHWebRequest YHWebRequestForPOST:kGetShare parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    _shareTitle = resultDic[@"title"];
                    _shareContent = resultDic[@"content"];
                    _shareUrl = [NSString stringWithFormat:@"%@&userPhone=%@",resultDic[@"url"],[DES3Util encrypt:self.phoneNum]];
                    __weak typeof(self) weakSelf = self;
                    //设置面板样式
                    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
                    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
                    //判断是否安装QQ,微信
                    NSMutableArray *platformArray = [NSMutableArray array];
                    if ([WXApi isWXAppInstalled]) {
                        [platformArray addObject:@(UMSocialPlatformType_WechatSession)];
                        [platformArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
                    }
                    if ([QQApiInterface isQQInstalled]) {
                        [platformArray addObject:@(UMSocialPlatformType_QQ)];
                        [platformArray addObject:@(UMSocialPlatformType_Qzone)];
                    }
//                    if ([WeiboSDK isWeiboAppInstalled]) {
//                        [platformArray addObject:@(UMSocialPlatformType_Sina)];
//                    }
                    //预定义平台
                    [UMSocialUIManager setPreDefinePlatforms:[NSArray arrayWithArray:platformArray]];
                    //显示分享面板
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        [weakSelf shareImageAndTextUrlToPlatformType:platformType];
                    }];
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
}
#pragma mark 分享错误信息提示
- (void)alertWithError:(NSError *)error{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }else{
        if (error) {
            result = [NSString stringWithFormat:@"分享被取消"];
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    [YHHud showWithMessage:result];
}
@end
