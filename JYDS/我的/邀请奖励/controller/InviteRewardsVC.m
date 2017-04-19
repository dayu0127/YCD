//
//  InviteRewardsVC.m
//  JYDS
//
//  Created by 大雨 on 2017/4/2.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "InviteRewardsVC.h"
#import "BaseWKWebView.h"
#import <UShareUI/UMSocialUIManager.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
@interface InviteRewardsVC ()
@property (strong,nonatomic) BaseWKWebView *wkWebView;
@end

@implementation InviteRewardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kInviteRewards]];
    [_wkWebView loadRequest:request];
    [self.view insertSubview:_wkWebView atIndex:0];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setTitle:@"邀请好友 领取优惠" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.backgroundColor = ORANGERED;
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [shareButton addTarget:self action:@selector(inviteShareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:shareButton atIndex:1];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@45);
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)inviteListClick:(UIButton *)sender {
    if (self.token==nil&&self.phoneNum==nil) {
        [self returnToLogin];
    }else{
        [self performSegueWithIdentifier:@"toInviteList" sender:self];
    }
}
#pragma mark 设置分享内容(图文链接)
- (void)shareImageAndTextUrlToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享的网页地址对象
    NSString *text = @"快来加入记忆大师";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"记忆大师邀请" descr:text thumImage:[UIImage imageNamed:@"icon-40"]];
    shareObject.webpageUrl = kShareRegister(self.phoneNum);
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
    if (self.token==nil&&self.phoneNum==nil) {
        [self returnToLogin];
    }else{
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
        //预定义平台
        [UMSocialUIManager setPreDefinePlatforms:[NSArray arrayWithArray:platformArray]];
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareImageAndTextUrlToPlatformType:platformType];
        }];
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
