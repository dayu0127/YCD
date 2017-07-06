//
//  BaseNavViewController.m
//  JYDS
//
//  Created by liyu on 2016/12/31.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BaseNavViewController.h"
#import <WebKit/WebKit.h>
#import <UShareUI/UMSocialUIManager.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "DES3Util.h"
#import <WeiboSDK.h>
@interface BaseNavViewController ()<WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *wkWebView;
@property (copy,nonatomic) NSString *shareTitle;
@property (copy,nonatomic) NSString *shareContent;
@end

@implementation BaseNavViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:_navTitle];
}
- (void)initNaBar:(NSString *)title{
    //导航栏
    _navBar = [UIView new];
    _navBar.backgroundColor = ORANGERED;
    [self.view addSubview:_navBar];
    [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    //返回按钮
    _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_leftBarButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBarButton];
    [_leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(7);
        make.width.height.mas_equalTo(@33);
    }];
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.text = _navTitle;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftBarButton.mas_centerY);
        make.leading.equalTo(self.leftBarButton.mas_trailing).offset(8);
    }];
    //页面
    [YHHud showWithStatus];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkUrl]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_linkUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [_wkWebView loadRequest:request];
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
//    [self.view insertSubview:_wkWebView atIndex:0];
    [self.view addSubview:_wkWebView];
    if (_isShowShareBtn == YES) {
        //分享按钮
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"memory_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(inviteShareClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view insertSubview:_shareButton atIndex:1];
        [self.view addSubview:_shareButton];
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-10);
            make.width.mas_equalTo(@33);
            make.height.mas_equalTo(@33);
            make.centerY.mas_equalTo(self.leftBarButton.mas_centerY);
        }];
        _shareButton.alpha = 0;
    }
}
- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    _shareButton.alpha = 1;
    [YHHud dismiss];
}
#pragma mark 设置分享内容(图文链接)
- (void)shareImageAndTextUrlToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享的网页地址对象
    NSString *title = _shareTitle;
    NSString *descr = _shareContent;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon-40"]];
    if (_isDynamic == YES) {
        shareObject.webpageUrl = _shareUrl;
    }else{
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@&userPhone=%@",_shareUrl,[DES3Util encrypt:self.phoneNum]];
    }
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
#pragma mark 邀请分享按钮点击事件
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
                    __weak typeof(self) weakSelf = self;
                    //设置面板样式
                    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
                    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
                    //判断是否安装QQ,微信
                    NSMutableArray *platformArray = [NSMutableArray array];
                    if ([WXApi isWXAppInstalled]) {
//                        [platformArray addObject:@(UMSocialPlatformType_WechatSession)];
                        [platformArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
                    }
                    if ([QQApiInterface isQQInstalled]) {
//                        [platformArray addObject:@(UMSocialPlatformType_QQ)];
                        [platformArray addObject:@(UMSocialPlatformType_Qzone)];
                    }
                    if ([WeiboSDK isWeiboAppInstalled]) {
                        [platformArray addObject:@(UMSocialPlatformType_Sina)];
                    }
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
