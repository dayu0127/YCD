//
//  SubscribedVC.m
//  JYDS
//
//  Created by dayu on 2016/11/25.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SecretsVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialResponse.h>
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "BaseWKWebView.h"
#import <UIImageView+WebCache.h>

@interface SecretsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *ruleButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIScrollView *ruleView;
@property (strong,nonatomic) UITableView *recordTableView;
@property (strong,nonatomic) NSArray *tableViewArray;
@property (strong,nonatomic) MJRefreshNormalHeader *header;
@property (strong,nonatomic) WKWebView *wkWebView;
@property (strong,nonatomic) UIImageView *rewardRulesImageView;

@end

@implementation SecretsVC
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
}
- (void)dayMode{
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_rewardRulesImageView sd_setImageWithURL:[NSURL URLWithString:InvitationDayUrl] placeholderImage:nil];
}
- (void)nightMode{
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [_rewardRulesImageView sd_setImageWithURL:[NSURL URLWithString:InvitationNightUrl] placeholderImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 116, WIDTH, HEIGHT-164)];
    _scrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT-164);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:self.ruleView];
    [self createRecordTableView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.x == 0) {
        [self ruleButtonSelected];
    }else{
        [self recordButtonSelected];
    }
}
- (void)nightModeConfiguration{
    [_ruleButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_recordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _ruleButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _recordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
}

#pragma mark 规则按钮点击
- (IBAction)ruleClick:(UIButton *)sender {
    [self ruleButtonSelected];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark 记录按钮点击
- (IBAction)recordClick:(UIButton *)sender {
    [self recordButtonSelected];
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
}
- (void)ruleButtonSelected{
    [_ruleButton dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    _ruleButton.selected = YES;
    [_recordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _recordButton.selected = NO;
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
}
- (void)recordButtonSelected{
    [_recordButton dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    _recordButton.selected = YES;
    [_ruleButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _ruleButton.selected = NO;
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self reloadRecordData];
}
#pragma mark 规则页面
- (UIScrollView *)ruleView{
    if (!_ruleView) {
        _ruleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-164)];
        _ruleView.contentSize = CGSizeMake(WIDTH, 208+WIDTH*730/414.0);
        //您的邀请码
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, WIDTH, 17)];
        titleLabel.text = @"您的邀请码";
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_ruleView addSubview:titleLabel];
        //按钮
        UIButton *inviteCodeButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-145)*0.5, CGRectGetMaxY(titleLabel.frame)+15, 145, 37)];
        inviteCodeButton.layer.masksToBounds = YES;
        inviteCodeButton.layer.cornerRadius = 5.0f;
        inviteCodeButton.layer.borderWidth = 1.0f;
        inviteCodeButton.titleLabel.font = [UIFont systemFontOfSize:22.0f];
        [inviteCodeButton setTitle:[YHSingleton shareSingleton].userInfo.studyCode forState:UIControlStateNormal];
        inviteCodeButton.layer.dk_borderColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        [inviteCodeButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        inviteCodeButton.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
        [inviteCodeButton addTarget:self action:@selector(inviteCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ruleView addSubview:inviteCodeButton];
        //点击可复制
        UILabel *copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(inviteCodeButton.frame)+10, WIDTH, 14)];
        copyLabel.text = @"点击可复制";
        copyLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        copyLabel.font = [UIFont systemFontOfSize:14.0f];
        copyLabel.textAlignment = NSTextAlignmentCenter;
        [_ruleView addSubview:copyLabel];
        //发送给好友
        UIButton *sendToFriendButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-145)*0.5, CGRectGetMaxY(copyLabel.frame)+20, 145, 37)];
        sendToFriendButton.layer.masksToBounds = YES;
        sendToFriendButton.layer.cornerRadius = 5.0f;
        sendToFriendButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [sendToFriendButton setTitle:@"发送给好友" forState:UIControlStateNormal];
        [sendToFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendToFriendButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        [sendToFriendButton addTarget:self action:@selector(sendToFriendClick) forControlEvents:UIControlEventTouchUpInside];
        [_ruleView addSubview:sendToFriendButton];
        //邀请规则
//        UILabel *rewardRulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sendToFriendButton.frame)+20, WIDTH-40, 50)];
//        rewardRulesLabel.text = @"邀请好友加入记忆大师，每一位好友使用该互学码注册加入，双方均可获得5学习豆奖励。";
//        rewardRulesLabel.font = [UIFont systemFontOfSize:12.0f];
//        rewardRulesLabel.numberOfLines = 2;
//        rewardRulesLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],RED);
//        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:rewardRulesLabel.text];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:10];
//        [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, rewardRulesLabel.text.length)];
//        rewardRulesLabel.attributedText = content;
//        [_ruleView addSubview:rewardRulesLabel];
        
//        _wkWebView = [[BaseWKWebView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(sendToFriendButton.frame)+20, WIDTH, 500)];
//        _wkWebView.scrollView.bounces = NO;
//        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:InvitationUrl]];
//        [_wkWebView loadRequest:request];
//        [_ruleView addSubview:_wkWebView];
        _rewardRulesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(sendToFriendButton.frame)+20, WIDTH, WIDTH*730/414.0)];
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
            [_rewardRulesImageView sd_setImageWithURL:[NSURL URLWithString:InvitationDayUrl]];
        }else{
            [_rewardRulesImageView sd_setImageWithURL:[NSURL URLWithString:InvitationNightUrl]];
        }
        [_ruleView addSubview:_rewardRulesImageView];
    }
    return _ruleView;
}
#pragma mark 记录页面
- (void)createRecordTableView{
    _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-164) style:UITableViewStylePlain];
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recordTableView.backgroundColor = [UIColor clearColor];
    [_recordTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [YHWebRequest YHWebRequestForPOST:INVITATION parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
            [self.recordTableView.mj_header endRefreshing];
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                _tableViewArray = json[@"data"];
                [_recordTableView reloadData];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"数据异常"];
            }
        } failure:^(NSError * _Nonnull error) {
            [self.recordTableView.mj_header endRefreshing];
            [YHHud showWithMessage:@"数据请求失败"];
        }];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    _header.lastUpdatedTimeLabel.hidden = YES;
    // 设置菊花样式
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }else{
        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    // 设置header
    self.recordTableView.mj_header = _header;
    [_scrollView addSubview:self.recordTableView];
    
}
- (void)reloadRecordData{
    if (_tableViewArray == nil) {
        [YHWebRequest YHWebRequestForPOST:INVITATION parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                _tableViewArray = json[@"data"];
                [_recordTableView reloadData];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"数据异常"];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud showWithMessage:@"数据请求失败"];
        }];
    }
}
#pragma mark 点击复制互学码
- (void)inviteCodeClick:(UIButton *)sender {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:sender.titleLabel.text];
    [YHHud showWithMessage:@"邀请码已复制到剪贴板"];
}
#pragma mark 设置分享内容(图文链接)
- (void)shareImageAndTextUrlToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享的网页地址对象
    NSString *text = [NSString stringWithFormat:@"我的邀请码是%@\n快来加入记忆大师",[YHSingleton shareSingleton].userInfo.studyCode];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"记忆大师邀请码" descr:text thumImage:[UIImage imageNamed:@"appLogo"]];
    shareObject.webpageUrl = @"https://www.jydsapp.com";
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
#pragma mark 发送给好友
- (void)sendToFriendClick{
    __weak typeof(self) weakSelf = self;
    //设置面板样式
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
    //判断是否安装QQ,微信,微博
    BOOL hasWX = [WXApi isWXAppInstalled];
    BOOL hasQQ = [QQApiInterface isQQInstalled];
    if (!hasQQ&&!hasWX) {
        [YHHud showWithMessage:@"请您先安装微信或QQ"];
    }else{
        NSMutableArray *platformArray = [NSMutableArray array];
        if (hasWX) {
            [platformArray addObject:@(UMSocialPlatformType_WechatSession)];
        }
        if (hasQQ) {
            [platformArray addObject:@(UMSocialPlatformType_QQ)];
        }
        //预定义平台
        [UMSocialUIManager setPreDefinePlatforms:[NSArray arrayWithArray:platformArray]];
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareImageAndTextUrlToPlatformType:platformType];
        }];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSString *str = _tableViewArray[indexPath.row][@"userNumber"];
    NSMutableString *phoneStr = [NSMutableString string];
    if (![@"" isEqualToString:str]) {
       phoneStr = [NSMutableString stringWithString:str];
       [phoneStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"用户%@加入记忆大师，您将享受%zd折优惠",phoneStr,9-indexPath.row];
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
