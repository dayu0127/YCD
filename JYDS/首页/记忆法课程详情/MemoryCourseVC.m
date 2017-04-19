//
//  MemoryCourseVC.m
//  JYDS
//
//  Created by dayu on 2016/11/29.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "MemoryCourseVC.h"
#import <ZFPlayer.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialResponse.h>
#import "Mnemonics.h"
//#import "PayVC.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <WeiboSDK.h>
@interface MemoryCourseVC ()<ZFPlayerDelegate,YHAlertViewDelegate>

@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *underLine;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UITextView *contentText;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIDocumentInteractionController *documentController;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) JCAlertView *alertView;
@property (nonatomic,strong) UIView *opaqueView;
@property (nonatomic,strong) UIButton *backBtn;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation MemoryCourseVC
// 返回值要必须为NO
- (BOOL)shouldAutorotate{
    return NO;
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    // pop回来时候是否自动播放
//    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
//        self.isPlaying = NO;
//        [self.playerView play];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    // push出下一级页面时候暂停
//    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser){
//        self.isPlaying = YES;
//        [self.playerView pause];
//    }
}
- (ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = _memory.courseName;
        _playerModel.videoURL         = [NSURL URLWithString:_memory.course_standby__videourl];
        _playerModel.placeholderImageURLString = _memory.courseImageUrl;
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (void)zf_playerBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _buttonArray = [NSMutableArray array];
    //播放器
    _playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 9/16.0*WIDTH)];
    [self.view addSubview:_playerFatherView];
    _playerView = [[ZFPlayerView alloc] init];
    _playerView.delegate = self;
    [_playerView playerControlView:nil playerModel:self.playerModel];
//    [self loadPlayerOpaqueView:_memory.coursePrice subStatus:_memory.coursePayStatus];
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+9/16.0*WIDTH, WIDTH, 39)];
    titleView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:titleView];
    //本节说明
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.24*WIDTH, 38)];
    _titleLabel.text = @"本节说明";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.dk_textColorPicker= DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [titleView addSubview:_titleLabel];
    //下划线
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 0.24*WIDTH, 1)];
    _underLine.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [titleView addSubview:_underLine];
    //分享
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-65, 0, 35, 39)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton dk_setTitleColorPicker:DKColorPickerWithColors([UIColor darkTextColor],[UIColor whiteColor],RED) forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shareButton];
    UIButton *shareImageButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-30, 11.5, 16, 16)];
    [shareImageButton dk_setImage:DKImagePickerWithNames(@"shareD",@"shareN",@"") forState:UIControlStateNormal];
    [shareImageButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shareImageButton];
    //分割线
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), WIDTH, 1)];
    _line.backgroundColor = SEPCOLOR;
    [self.view addSubview:_line];
    //本节说明(其他课程)
    [self loadCurrentSectionExplain:_memory.courseInstructions];
}
#pragma mark 加载播放器遮罩视图
- (void)loadPlayerOpaqueView:(NSString *)price subStatus:(NSString *)status{
    if (_backBtn!=nil) {
        [_backBtn removeFromSuperview];
        _backBtn = nil;
    }
    if (_opaqueView!=nil) {
        [_opaqueView removeFromSuperview];
        _opaqueView = nil;
    }
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_backBtn addTarget:self action:@selector(zf_playerBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_playerView addSubview:_backBtn];
    //记忆法课程购买
    _opaqueView = [[UIView alloc] initWithFrame:_playerFatherView.bounds];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"videoBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(zf_playerBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_opaqueView addSubview:backButton];
    UIImage *playerBtn = [UIImage imageNamed:@"playerBtn"];
    UIImageView *playImageView = [[UIImageView alloc] initWithImage:playerBtn];
    playImageView.center = CGPointMake(WIDTH*0.5, _playerFatherView.bounds.size.height*0.5);
    playImageView.bounds = CGRectMake(0, 0, playerBtn.size.width, playerBtn.size.height);
    [_opaqueView addSubview:playImageView];
    UILabel *payPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(playImageView.frame)+14, WIDTH, 15)];
    payPriceLabel.font = [UIFont systemFontOfSize:15.0f];
    payPriceLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    payPriceLabel.text = [NSString stringWithFormat:@"需花费%@%@",price,[YHSingleton shareSingleton].bannerTxt];
    payPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_opaqueView addSubview:payPriceLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyMemoryCourse)];
    [_opaqueView addGestureRecognizer:tap];
    [_playerView addSubview:_opaqueView];
    if ([status isEqualToString:@"0"]) {
        _opaqueView.alpha = 1;
    }else{
        _opaqueView.alpha = 0;
    }
}
- (void)buyMemoryCourse{
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 100) title:@"确定购买？" message:nil];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
        //用户学习豆不够，跳转到充值页面
//        NSInteger studyBean = [[YHSingleton shareSingleton].userInfo.studyBean integerValue];
//        if (studyBean < [_memory.coursePrice integerValue]) {
//            [YHHud showWithMessage:@"余额不足"];
//        }else{
//            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"productID":_memory.courseID,@"type":@"memory",@"device_id":DEVICEID};
//            [YHWebRequest YHWebRequestForPOST:SUB parameters:dic success:^(NSDictionary *json) {
//                if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//                    [self returnToLogin];
//                }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                    [YHHud showWithSuccess:@"订阅成功"];
//                    _opaqueView.alpha = 0;
//                    [_delegate reloadMemoryList];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
//                }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                    [YHHud showWithMessage:@"服务器错误"];
//                }else{
//                    [YHHud showWithMessage:@"订阅失败"];
//                }
//            } failure:^(NSError * _Nonnull error) {
//                [YHHud showWithMessage:@"数据请求失败"];
//            }];
//        }
    }
}
#pragma mark 设置分享内容(图文链接)
- (void)shareImageAndTextUrlToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    //分享的网页地址对象
//    NSString *text = [NSString stringWithFormat:@"我的邀请码是%@\n快来加入记忆大师",[YHSingleton shareSingleton].userInfo.studyCode];
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"记忆大师邀请码" descr:text thumImage:[UIImage imageNamed:@"appLogo"]];
//    shareObject.webpageUrl = @"https://www.jydsapp.com";
//    messageObject.shareObject = shareObject;
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        [self alertWithError:error];
//    }];
}
#pragma mark 分享
- (void)shareButtonClick{
    __weak typeof(self) weakSelf = self;
    //设置面板样式
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"请选择分享平台";
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消分享";
    //判断是否安装QQ,微信,微博
    NSMutableArray *platformArray = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [platformArray addObject:@(UMSocialPlatformType_WechatSession)];
        [platformArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    if ([QQApiInterface isQQInstalled]) {
        [platformArray addObject:@(UMSocialPlatformType_QQ)];
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
#pragma mark 加载本节说明
- (void)loadCurrentSectionExplain:(NSString *)text{
    _contentText = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame))];
    _contentText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentText.editable = NO;
    NSString *textString = text;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textString.length)];
    _contentText.attributedText = content;
    _contentText.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _contentText.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _contentText.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:_contentText];
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
