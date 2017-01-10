//
//  RememberWordVideoDetailVC.m
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordVideoDetailVC.h"
#import "RememberWordSingleWordDetailVC.h"
#import <ZFPlayer.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialCore/UMSocialResponse.h>
#import <UShareUI/UMSocialUIManager.h>
#import "CourseVideo.h"
#import "PayVC.h"
#import "Words.h"

@interface RememberWordVideoDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZFPlayerDelegate,YHAlertViewDelegate>

@property (strong, nonatomic) UIView *playerFatherView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (nonatomic,strong)NSMutableArray *buttonAarry;
@property (nonatomic,strong)UIView *underLine;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)NSArray *wordArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)NSInteger flagForCollectionView;
@property (nonatomic,strong)NSMutableArray *courseButtonArray;
@property (nonatomic,strong) JCAlertView *alertView;
@property (nonatomic,strong) UIView *opaqueView;
@property (nonatomic,strong) UILabel *payPriceLabel;
@property (nonatomic,strong) UIButton *backBtn;
@property (assign,nonatomic) BOOL isHiddenNav;

@end

@implementation RememberWordVideoDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
// 返回值要必须为NO
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)zf_playerBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.video.videoName;
        _playerModel.videoURL         = [NSURL URLWithString:self.video.videoUrl];
//        _playerModel.placeholderImage = [UIImage imageNamed:@""];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _courseButtonArray = [NSMutableArray array];
    //播放器父视图
    _playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 9/16.0*WIDTH)];
    [self.view addSubview:_playerFatherView];
    _playerView = [[ZFPlayerView alloc] init];
    _playerView.delegate = self;
    [_playerView playerControlView:nil playerModel:self.playerModel];
    [self loadPlayerOpaqueView:_video.videoPrice subStatus:_video.productType];
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+9/16.0*WIDTH, WIDTH, 39)];
    titleView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:titleView];
    _buttonAarry = [NSMutableArray arrayWithCapacity:3];
    NSArray *titleArray = @[@"本节说明",@"本节单词",@"其他节课"];
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.24*WIDTH*i, 0, 0.24*WIDTH, 38)];
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [btn dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        btn.tag = i;
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        [_buttonAarry addObject:btn];
    }
    //下划线
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 0.24*WIDTH, 1)];
    _underLine.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [titleView addSubview:_underLine];
    //分享
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-65, 0, 35, 39)];
    shareLabel.text = @"分享";
    shareLabel.font = [UIFont systemFontOfSize:15.0f];
    shareLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkTextColor],[UIColor whiteColor],RED);
    [titleView addSubview:shareLabel];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-30, 11.5, 16, 16)];
    [shareButton dk_setImage:DKImagePickerWithNames(@"shareD",@"shareN",@"") forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shareButton];
    //分割线
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), WIDTH, 1)];
    _line.backgroundColor = SEPCOLOR;
    [self.view addSubview:_line];
    //本节说明(本节单词,其他课程)
    [self loadCurrentSectionExplain:_video.videoDetail];
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
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton sizeToFit];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyVideo)];
    [_opaqueView addGestureRecognizer:tap];
    [_playerView addSubview:_opaqueView];
    if ([status isEqualToString:@"0"]) {
        _opaqueView.alpha = 1;
    }else{
        _opaqueView.alpha = 0;
    }
}
#pragma mark 选项卡标题点击
- (void)titleButtonClick:(UIButton *)sender{
    for (UIButton *item in _buttonAarry) {
        [item dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        item.selected = NO;
    }
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    _underLine.frame = CGRectMake(0.24*WIDTH*sender.tag, 38, 0.24*WIDTH, 1);
    if (sender.tag == 0) { //点击加载本节说明
        [self loadCurrentSectionExplain:_video.videoDetail];
    }else if(sender.tag == 1){ //点击加载本节单词
        _flagForCollectionView = 0;
        [self loadWordOrOtherCourse];
    }else{
        _flagForCollectionView = 1;
        _courseButtonArray = [NSMutableArray array];
        [self loadWordOrOtherCourse];
    }
}
#pragma mark 设置分享内容
#pragma mark 分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"记忆大师分享内容";
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
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_Sina) {
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_Sina];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_QQ];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_Qzone];
        }
    }];
}
#pragma mark 加载本节说明
- (void)loadCurrentSectionExplain:(NSString *)text{
    if (_contentText!=nil) {
        [_contentText removeFromSuperview];
        _contentText = nil;
    }
    _contentText = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame))];
    _contentText.editable = NO;
    _contentText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
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
#pragma mark 加载本节单词/其他课程
- (void)loadWordOrOtherCourse{
    if (_flagForCollectionView == 0) {
        [YHWebRequest YHWebRequestForPOST:WORDBYVIDEOID parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"id":_video.videoID} success:^(NSDictionary *json) {
            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                _wordArray = json[@"data"];
                [self initCollectionView:0];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"数据异常"];
            }
        }];
    }else{
        [self initCollectionView:1];
    }
}
- (void)initCollectionView:(NSInteger)index{
    if (_collectionView!=nil) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    if (index == 0) {
        layout.itemSize = CGSizeMake((WIDTH-60)*0.5, 44);
        layout.sectionInset = UIEdgeInsetsMake(10,15,10,15);
    }else{
        layout.itemSize = CGSizeMake(WIDTH-40, 44);
        layout.sectionInset = UIEdgeInsetsMake(10,20,10,20);
    }
    layout.minimumLineSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _flagForCollectionView == 0 ? self.wordArray.count : self.videoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CGFloat width = _flagForCollectionView == 0 ? (WIDTH-60)*0.5 : (WIDTH-40);
    UIButton *courseItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    NSString *title = _flagForCollectionView == 0 ? self.wordArray[indexPath.row][@"word"] : self.videoArray[indexPath.row][@"videoName"];
    [courseItemButton setTitle:title forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [courseItemButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    courseItemButton.tag = indexPath.row;
    courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    courseItemButton.layer.masksToBounds = YES;
    courseItemButton.layer.cornerRadius = 8.0f;
    if (_flagForCollectionView == 0) {
        [courseItemButton addTarget:self action:@selector(wordItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if ([[NSString stringWithFormat:@"%@",self.videoArray[indexPath.row][@"videoID"]] isEqualToString:_video.videoID]) {
            courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        }
        [courseItemButton addTarget:self action:@selector(courseItemButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [courseItemButton addTarget:self action:@selector(courseItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_courseButtonArray addObject:courseItemButton];
    }
    [cell.contentView addSubview:courseItemButton];
    return cell;
}
- (void)wordItemButtonClick:(UIButton *)sender{
    RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
    wordDetailVC.word = [Words yy_modelWithJSON:_wordArray[sender.tag]];
    _isHiddenNav = NO;
    [self.navigationController pushViewController:wordDetailVC animated:YES];
}
- (void)courseItemButtonTouchDown:(UIButton *)sender{
    for (UIButton *btn in _courseButtonArray) {
        btn.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    }
    sender.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)courseItemButtonClick:(UIButton *)sender{
    NSString *videoID = _videoArray[sender.tag][@"videoID"];
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"id":videoID};
    [YHWebRequest YHWebRequestForPOST:VIDEOBYID parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _video = [CourseVideo yy_modelWithJSON:json[@"data"]];
            _playerModel = [[ZFPlayerModel alloc] init];
            _playerModel.title = _video.videoName;
            _playerModel.fatherView = self.playerFatherView;
            _playerModel.videoURL = [NSURL URLWithString:_video.videoUrl];
            [_playerView resetPlayer];
            [_playerView playerControlView:nil playerModel:_playerModel];
            [self loadPlayerOpaqueView:_video.videoPrice subStatus:_video.productType];
            for (UIButton *item in _buttonAarry) {
                [item dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
                item.selected = NO;
            }
            UIButton *firstButton = (UIButton *)[_buttonAarry objectAtIndex:0];
            [firstButton dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
            firstButton.selected = YES;
            _underLine.frame = CGRectMake(0, 38, 0.24*WIDTH, 1);
            [self loadCurrentSectionExplain:_video.videoDetail];
            [_collectionView reloadData];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    }];
}
- (void)buyVideo{
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
        if (studyBean < [_video.videoPrice integerValue]) {
            [YHHud showWithMessage:@"您的学习豆不足，请充值"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isHiddenNav = YES;
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
                payVC.isHiddenNav = YES;
                [self.navigationController pushViewController:payVC animated:YES];
            });
        }else{
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"productID":_video.videoID,@"type":@"k12",@"money":_video.videoPrice};
            [YHWebRequest YHWebRequestForPOST:SUB parameters:dic success:^(NSDictionary *json) {
                if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                    [YHHud showWithSuccess:@"订阅成功"];
                    _opaqueView.alpha = 0;
                    [_delegate reloadVideoList];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadVideos" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBean" object:nil];
                }else if([json[@"code"] isEqualToString:@"ERROR"]){
                    [YHHud showWithMessage:@"服务器错误"];
                }else{
                    [YHHud showWithMessage:@"订阅失败"];
                }
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHiddenNav == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
@end
