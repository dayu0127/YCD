//
//  RememberWordSingleWordDetailVC.m
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordSingleWordDetailVC.h"
#import <ZFPlayer.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialResponse.h>
#import "Words.h"
#import <WebKit/WebKit.h>
#import "PayVC.h"

@interface RememberWordSingleWordDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZFPlayerDelegate,YHAlertViewDelegate>

@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (nonatomic,strong)UIButton *titleButton1;
@property (nonatomic,strong)UIButton *titleButton2;
@property (nonatomic,strong)UIView *underLine;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) JCAlertView *alertView;
@property (nonatomic,strong) UIView *opaqueView;
@property (nonatomic,strong) UILabel *payPriceLabel;
@property (nonatomic,strong) NSArray *unitWordArray;

@end

@implementation RememberWordSingleWordDetailVC
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
        _playerModel.title            = self.word.word;
        _playerModel.videoURL         = [NSURL URLWithString:self.word.wordVideoUrl];
//        _playerModel.placeholderImage = [UIImage imageNamed:@"banner01"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
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
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(zf_playerBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_playerView addSubview:backBtn];
    //记忆法课程购买
    if ([_word.payType isEqualToString:@"0"]) {
        _opaqueView = [[UIView alloc] initWithFrame:_playerFatherView.bounds];
        UIImage *playerBtn = [UIImage imageNamed:@"playerBtn"];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(12.1, 7.8, 30, 30);
        [backButton setImage:[UIImage imageNamed:@"ZFPlayer_back_full"] forState:UIControlStateNormal];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(zf_playerBackAction) forControlEvents:UIControlEventTouchUpInside];
        [_opaqueView addSubview:backButton];
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:playerBtn];
        playImageView.center = CGPointMake(WIDTH*0.5, _playerFatherView.bounds.size.height*0.5);
        playImageView.bounds = CGRectMake(0, 0, playerBtn.size.width, playerBtn.size.height);
        [_opaqueView addSubview:playImageView];
        _payPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(playImageView.frame)+14, WIDTH, 15)];
        _payPriceLabel.font = [UIFont systemFontOfSize:15.0f];
        _payPriceLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        _payPriceLabel.text = [NSString stringWithFormat:@"需花费%@学习豆",_word.wordPrice];
        _payPriceLabel.textAlignment = NSTextAlignmentCenter;
        [_opaqueView addSubview:_payPriceLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyWord)];
        [_opaqueView addGestureRecognizer:tap];
        [_playerView addSubview:_opaqueView];
    }
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+9/16.0*WIDTH, WIDTH, 39)];
    titleView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:titleView];
    //释义
    _titleButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.24*WIDTH, 38)];
    [_titleButton1 setTitle:@"释义" forState:UIControlStateNormal];
    [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
    _titleButton1.selected = YES;
    _titleButton1.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton1.tag = 0;
    [_titleButton1 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton1];
    //相关词语
    _titleButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0.24*WIDTH, 0, 0.24*WIDTH, 38)];
    [_titleButton2 setTitle:@"相关词语" forState:UIControlStateNormal];
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
    //释义(相关词语)
    [self loadParaphrase];
}
#pragma mark 选项卡标题点击
- (void)titleButtonClick:(UIButton *)sender{
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    _underLine.frame = CGRectMake(0.24*WIDTH*sender.tag, 38, 0.24*WIDTH, 1);
    if (sender.tag == 0) { //点击加载释义
        [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        _titleButton2.selected = NO;
        [self loadParaphrase];
    }else{  //点击加载相关词语
        [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        _titleButton1.selected = NO;
        [self loadRelatedWords];
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
#pragma mark 加载释义
- (void)loadParaphrase{
    if (_wkWebView!=nil) {
        [_wkWebView removeFromSuperview];
        _wkWebView = nil;
    }
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame))];
    [_wkWebView loadHTMLString:_word.wordDetail baseURL:nil];
    [self.view addSubview:_wkWebView];
}
#pragma mark 加载相关词语
- (void)loadRelatedWords{
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"id":_word.wordID};
    [YHWebRequest YHWebRequestForPOST:UNITWORDBYID parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _unitWordArray = json[@"data"];
            if (_collectionView!=nil) {
                [_collectionView removeFromSuperview];
                _collectionView = nil;
                [_buttonArray removeAllObjects];
                _buttonArray = nil;
            }
            _buttonArray = [NSMutableArray array];
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake((WIDTH-60)*0.5, 44);
            layout.minimumLineSpacing = 10; //上下的间距 可以设置0看下效果
            layout.sectionInset = UIEdgeInsetsMake(10,15,10,15);
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame)) collectionViewLayout:layout];
            _collectionView.delegate = self;
            _collectionView.dataSource =self;
            _collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
            [self.view addSubview:_collectionView];
            [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        }
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _unitWordArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIButton *courseItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (WIDTH-60)*0.5, 44)];
    [courseItemButton setTitle:_unitWordArray[indexPath.row][@"word"] forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [courseItemButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    courseItemButton.tag = indexPath.row;
    courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    courseItemButton.layer.masksToBounds = YES;
    courseItemButton.layer.cornerRadius = 8.0f;
    [courseItemButton addTarget:self action:@selector(relatedWordsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:courseItemButton];
    [_buttonArray addObject:courseItemButton];
    return cell;
}
- (void)relatedWordsButtonClick:(UIButton *)sender{
    for (UIButton *btn in _buttonArray) {
        btn.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    }
    UIButton *currentBtn = [_buttonArray objectAtIndex:sender.tag];
    currentBtn.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"id":[NSString stringWithFormat:@"%zd",sender.tag]};
    [YHWebRequest YHWebRequestForPOST:MEMORYBYID parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            Words *model = [Words yy_modelWithJSON:json[@"data"]];
            _playerModel = [[ZFPlayerModel alloc] init];
            _playerModel.title = model.word;
            _playerModel.fatherView = self.playerFatherView;
            _playerModel.videoURL = [NSURL URLWithString:model.wordVideoUrl];
            [_playerView resetPlayer];
            [_playerView playerControlView:nil playerModel:_playerModel];
            if ([model.payType isEqualToString:@"0"]) {
                _opaqueView.alpha = 1;
                _payPriceLabel.text = [NSString stringWithFormat:@"需花费%@学习豆",model.wordPrice];
            }else{
                _opaqueView.alpha = 0;
            }
            [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
            _titleButton1.selected = YES;
            _underLine.frame = CGRectMake(0, 38, 0.24*WIDTH, 1);
            [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
            _titleButton2.selected = NO;
            [self loadParaphrase];
        }
    }];
}
- (void)buyWord{
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
        if (studyBean < [_word.wordPrice integerValue]) {
            [YHHud showWithMessage:@"您的学习豆不足，请充值"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
                payVC.isH = YES;
                [self.navigationController pushViewController:payVC animated:YES];
            });
        }else{
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"productID":_word.wordID,@"type":@"word",@"money":_word.wordPrice};
            [YHWebRequest YHWebRequestForPOST:SUB parameters:dic success:^(NSDictionary *json) {
                if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                    [YHHud showWithSuccess:@"购买成功"];
                    [_opaqueView removeFromSuperview];
                    _opaqueView = nil;
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
@end
