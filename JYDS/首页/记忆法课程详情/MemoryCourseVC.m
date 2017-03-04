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
#import "PayVC.h"
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WeiboSDK.h>
@interface MemoryCourseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZFPlayerDelegate,YHAlertViewDelegate>

@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (nonatomic,strong) UIButton *titleButton1;
@property (nonatomic,strong) UIButton *titleButton2;
@property (nonatomic,strong) UIView *underLine;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UITextView *contentText;
@property (nonatomic,strong) NSMutableArray *courceArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIDocumentInteractionController *documentController;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) JCAlertView *alertView;
@property (nonatomic,strong) UIView *opaqueView;
@property (nonatomic,strong) UIButton *backBtn;

@end

@implementation MemoryCourseVC
// 返回值要必须为NO
- (BOOL)shouldAutorotate{
    return NO;
}
- (ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = _memory.courseName;
        _playerModel.videoURL         = [NSURL URLWithString:_memory.courseVideo];
//        _playerModel.placeholderImage = [UIImage imageNamed:@""];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (void)zf_playerBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)zf_playerDownload:(NSString *)url
//{
//    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
//}
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
    [self loadPlayerOpaqueView:_memory.coursePrice subStatus:_memory.coursePayStatus];
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+9/16.0*WIDTH, WIDTH, 39)];
    titleView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:titleView];
    //本节说明
    _titleButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.24*WIDTH, 38)];
    [_titleButton1 setTitle:@"本节说明" forState:UIControlStateNormal];
    _titleButton1.selected = YES;
    [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
    _titleButton1.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton1.tag = 0;
    [_titleButton1 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton1];
    //其他课程
    _titleButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0.24*WIDTH, 0, 0.24*WIDTH, 38)];
    [_titleButton2 setTitle:@"其他课程" forState:UIControlStateNormal];
    [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
    _titleButton2.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton2.tag = 1;
    [_titleButton2 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton2];
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
    payPriceLabel.text = [NSString stringWithFormat:@"需花费%@学习豆",price];
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
        NSInteger studyBean = [[YHSingleton shareSingleton].userInfo.studyBean integerValue];
        if (studyBean < [_memory.coursePrice integerValue]) {
            [YHHud showWithMessage:@"您的学习豆不足，请充值"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
                payVC.isHiddenNav = YES;
                [self.navigationController pushViewController:payVC animated:YES];
            });
        }else{
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"productID":_memory.courseID,@"type":@"memory",@"device_id":DEVICEID};
            [YHWebRequest YHWebRequestForPOST:SUB parameters:dic success:^(NSDictionary *json) {
                if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线提醒" message:@"该账号已在其他设备上登录" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
                        [app.window setRootViewController:loginVC];
                        [app.window makeKeyWindow];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                    [YHHud showWithSuccess:@"订阅成功"];
                    _opaqueView.alpha = 0;
                    [_delegate reloadMemoryList];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
                }else if([json[@"code"] isEqualToString:@"ERROR"]){
                    [YHHud showWithMessage:@"服务器错误"];
                }else{
                    [YHHud showWithMessage:@"订阅失败"];
                }
            }];
        }
    }
}
- (NSMutableArray *)courceArray{
    if (!_courceArray) {
        _courceArray = [NSMutableArray arrayWithObjects:@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程", nil];
    }
    return _courceArray;
}
#pragma mark 选项卡标题点击
- (void)titleButtonClick:(UIButton *)sender{
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    _underLine.frame = CGRectMake(0.24*WIDTH*sender.tag, 38, 0.24*WIDTH, 1);
    if (sender.tag == 0) { //点击本节说明
        [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        _titleButton2.selected = NO;
        [self loadCurrentSectionExplain:_memory.courseInstructions];
    }else{  //点击其他课程
        [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        _titleButton1.selected = NO;
        [self loadOtherCourse];
    }
}
#pragma mark 设置分享内容(图文链接)
- (void)shareImageAndTextUrlToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享的网页地址对象
    NSString *text = [NSString stringWithFormat:@"我的邀请码是%@\n快来加入记忆大师",[YHSingleton shareSingleton].userInfo.studyCode];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"记忆大师邀请码" descr:text thumImage:[UIImage imageNamed:@"appLogo"]];
    shareObject.webpageUrl = @"www.jydsapp.com";
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
#pragma mark 分享
- (void)shareButtonClick{
    __weak typeof(self) weakSelf = self;
    //设置面板样式
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"请选择分享平台";
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消分享";
    //判断是否安装QQ,微信,微博
    BOOL hasWX = [WXApi isWXAppInstalled];
    BOOL hasQQ = [QQApiInterface isQQInstalled];
    BOOL hasWeibo = [WeiboSDK isWeiboAppInstalled];
    if (!hasQQ&&!hasWX&&!hasWeibo) {
        [YHHud showWithMessage:@"请您先安装微信，QQ或新浪微博"];
    }else{
        NSMutableArray *platformArray = [NSMutableArray array];
        if (hasWX) {
            [platformArray addObject:@(UMSocialPlatformType_WechatSession)];
            [platformArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
        }
        if (hasQQ) {
            [platformArray addObject:@(UMSocialPlatformType_QQ)];
            [platformArray addObject:@(UMSocialPlatformType_Qzone)];
        }
        if (hasWeibo) {
            [platformArray addObject:@(UMSocialPlatformType_Sina)];
        }
        //预定义平台
        [UMSocialUIManager setPreDefinePlatforms:[NSArray arrayWithArray:platformArray]];
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareImageAndTextUrlToPlatformType:platformType];
        }];
    }
}
#pragma mark 加载本节说明
- (void)loadCurrentSectionExplain:(NSString *)text{
    if (_contentText!=nil) {
        [_contentText removeFromSuperview];
        _contentText = nil;
    }
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
#pragma mark 加载其他课程
- (void)loadOtherCourse{
    if (_collectionView!=nil) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
        [_buttonArray removeAllObjects];
        _buttonArray = nil;
    }
    _buttonArray = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((WIDTH-60)*0.5, 44);
    layout.minimumLineSpacing = 15; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(15,15,15,15);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _memoryArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIButton *courseItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (WIDTH-60)*0.5, 44)];
    Mnemonics *model = [Mnemonics yy_modelWithJSON:_memoryArray[indexPath.row]];
    [courseItemButton setTitle:model.courseName forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [courseItemButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    if ([model.courseID isEqualToString:_memory.courseID]) {
        courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    }else{
        courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    }
    courseItemButton.layer.masksToBounds = YES;
    courseItemButton.layer.cornerRadius = 8.0f;
    courseItemButton.tag = [model.courseID integerValue];
    [courseItemButton addTarget:self action:@selector(courseItemButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [courseItemButton addTarget:self action:@selector(courseItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:courseItemButton];
    [_buttonArray addObject:courseItemButton];
    return cell;
}
- (void)courseItemButtonTouchDown:(UIButton *)sender{
    for (UIButton *btn in _buttonArray) {
        btn.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    }
    sender.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)courseItemButtonClick:(UIButton *)sender{
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"id":[NSString stringWithFormat:@"%zd",sender.tag],@"device_id":DEVICEID};
    [YHWebRequest YHWebRequestForPOST:MEMORYBYID parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线提醒" message:@"该账号已在其他设备上登录" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
                [app.window setRootViewController:loginVC];
                [app.window makeKeyWindow];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _memory = [Mnemonics yy_modelWithJSON:json[@"data"]];
            _playerModel = [[ZFPlayerModel alloc] init];
            _playerModel.title = _memory.courseName;
            _playerModel.fatherView = self.playerFatherView;
            _playerModel.videoURL = [NSURL URLWithString:_memory.courseVideo];
            [_playerView resetPlayer];
            [_playerView playerControlView:nil playerModel:_playerModel];
            [self loadPlayerOpaqueView:_memory.coursePrice subStatus:_memory.coursePayStatus];
            [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
            _titleButton1.selected = YES;
            _underLine.frame = CGRectMake(0, 38, 0.24*WIDTH, 1);
            [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
            _titleButton2.selected = NO;
            [self loadCurrentSectionExplain:_memory.courseInstructions];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    }];
}
#pragma mark 分享错误信息提示
- (void)alertWithError:(NSError *)error{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }else{
//        NSMutableString *str = [NSMutableString string];
//        if (error.userInfo) {
//            for (NSString *key in error.userInfo) {
//                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
//            }
//        }
        if (error) {
//            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            result = [NSString stringWithFormat:@"分享被取消"];
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    [YHHud showWithMessage:result];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
@end
