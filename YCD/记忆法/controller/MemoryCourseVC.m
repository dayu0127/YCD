//
//  MemoryCourseVC.m
//  YCD
//
//  Created by dayu on 2016/11/29.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "MemoryCourseVC.h"
#import <ZFPlayer.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialResponse.h>
@interface MemoryCourseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZFPlayerDelegate>

@property (strong, nonatomic) UIView *playerFatherView;
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
@end

@implementation MemoryCourseVC

// 返回值要必须为NO
- (BOOL)shouldAutorotate{
    return NO;
}
- (ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
//        _playerModel.title            = self.videoName;
        _playerModel.videoURL         = self.videoURL;
//        _playerModel.placeholderImage = [UIImage imageNamed:@"banner01"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
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
    _buttonArray = [NSMutableArray array];
    //播放器
    _playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 9/16.0*WIDTH)];
    [self.view addSubview:_playerFatherView];
    _playerView = [[ZFPlayerView alloc] init];
    _playerView.delegate = self;
    [_playerView playerControlView:nil playerModel:self.playerModel];
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+9/16.0*WIDTH, WIDTH, 39)];
    titleView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:titleView];
    //本节说明
    _titleButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 38)];
    [_titleButton1 setTitle:@"本节说明" forState:UIControlStateNormal];
    _titleButton1.selected = YES;
    [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_titleButton1 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
    _titleButton1.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton1.tag = 0;
    [_titleButton1 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton1];
    //其他课程
    _titleButton2 = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 90, 38)];
    [_titleButton2 setTitle:@"其他课程" forState:UIControlStateNormal];
    [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_titleButton2 dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
    _titleButton2.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton2.tag = 1;
    [_titleButton2 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton2];
    //下划线
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 90, 1)];
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
    [shareImageButton setImage:[UIImage imageNamed:@"wodezixuan"] forState:UIControlStateNormal];
    [shareImageButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shareImageButton];
    //分割线
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), WIDTH, 1)];
    _line.backgroundColor = SEPCOLOR;
    [self.view addSubview:_line];
    //本节说明(其他课程)
    [self loadCurrentSectionExplain];
}
- (NSMutableArray *)courceArray{
    if (!_courceArray) {
        _courceArray = [NSMutableArray arrayWithObjects:@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程", nil];
    }
    return _courceArray;
}
#pragma mark 选项卡标题点击
- (void)titleButtonClick:(UIButton *)sender{
    sender.selected = YES;
    _underLine.frame = CGRectMake(90*sender.tag, 38, 90, 1);
    if (sender.tag == 0) { //点击本节说明
        _titleButton2.selected = NO;
        [self loadCurrentSectionExplain];
    }else{  //点击其他课程
        _titleButton1.selected = NO;
        [self loadOtherCourse];
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
#pragma mark 分享(本地/网络)图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图(本地/网络)
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:[UIImage imageNamed:@"logo"]];
    //分享消息对象设置分享内容对象
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
#pragma mark 分享图文（新浪支持，微信/QQ仅支持图片或文本分享)
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"记忆大师分享内容";
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    shareObject.shareImage = [UIImage imageNamed:@"logo"];
    //分享消息对象设置分享内容对象
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
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_Sina) {
            [weakSelf shareImageAndTextToPlatformType:UMSocialPlatformType_Sina];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_QQ];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareImageToPlatformType:UMSocialPlatformType_Qzone];
        }
    }];
}

#pragma mark 加载本节说明
- (void)loadCurrentSectionExplain{
    if (_contentText!=nil) {
        [_contentText removeFromSuperview];
        _contentText = nil;
    }
    _contentText = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame))];
    _contentText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentText.editable = NO;
    NSString *textString = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它。  --阿尔伯特·爱因斯坦";
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
    return self.courceArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIButton *courseItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (WIDTH-60)*0.5, 44)];
    [courseItemButton setTitle:self.courceArray[indexPath.row] forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [courseItemButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    courseItemButton.layer.masksToBounds = YES;
    courseItemButton.layer.cornerRadius = 8.0f;
    courseItemButton.tag = indexPath.row;
    [courseItemButton addTarget:self action:@selector(courseItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:courseItemButton];
    [_buttonArray addObject:courseItemButton];
    return cell;
}
- (void)courseItemButtonClick:(UIButton *)sender{
    for (UIButton *btn in _buttonArray) {
        btn.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    }
    UIButton *currentBtn = [_buttonArray objectAtIndex:sender.tag];
    currentBtn.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
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
@end
