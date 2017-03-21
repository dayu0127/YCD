//
//  RememberWordSingleWordDetailVC.m
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordSingleWordDetailVC.h"
#import "Words.h"
#import "PayVC.h"
#import <AVFoundation/AVFoundation.h>
#import <UIImageView+WebCache.h>
@interface RememberWordSingleWordDetailVC ()
@property (nonatomic,strong) AVSpeechSynthesizer *player;
@property (nonatomic,strong) UILabel *wordLabel;
@property (nonatomic,strong) UIView *soundmarkView;
@property (nonatomic,strong) UILabel *soundmarkLabel;
@property (nonatomic,strong) UIButton *soundButton;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *splitTitleLabel;
@property (nonatomic,strong) UILabel *splitLabel;
@property (nonatomic,strong) UILabel *associateTitleLabel;
@property (nonatomic,strong) UILabel *associateLabel;
@property (nonatomic,strong) UIButton *preButton;
@property (nonatomic,strong) UIButton *nextButton;

@end

@implementation RememberWordSingleWordDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
}
- (void)dayMode{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)nightMode{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        [self dayMode];
    }else{
        [self nightMode];
    }
    //返回按钮
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 20, 44, 44);
    [leftBarButton dk_setImage:DKImagePickerWithNames(@"back_night",@"back",@"") forState:UIControlStateNormal];
    leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBarButton];
    
    BOOL hasImage = [_word.wordImgUrl isEqualToString:@""];
    //单词
    CGFloat y1 = hasImage ?  78*(HEIGHT-64)/603 : 28;
    _wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,  y1, WIDTH-50, 30)];
    _wordLabel.text = _word.word;
    _wordLabel.dk_textColorPicker = DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED);
    _wordLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    _wordLabel.textAlignment = hasImage ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    [self.view addSubview:_wordLabel];
    
    //音标
    CGFloat w1 = [_word.phonogram boundingRectWithSize:CGSizeMake(1000, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil] context:nil].size.width;
    UIImage *soundImage = [UIImage imageNamed:@"sound"];
    CGFloat w2 = soundImage.size.width;
    CGFloat h = soundImage.size.height;
    CGFloat x1 = hasImage ? 25 : (WIDTH-w1-w2-10)*0.5;
    CGFloat y2 = hasImage ? 36 : 26;
    _soundmarkView = [[UIView alloc] initWithFrame:CGRectMake(x1, CGRectGetMaxY(_wordLabel.frame)+y2*(HEIGHT-64)/603.0, w1+w2+10, h)];
     [self.view addSubview:_soundmarkView];
    //音标字符串
    _soundmarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w1, h)];
    _soundmarkLabel.text = _word.phonogram;
    _soundmarkLabel.textAlignment = NSTextAlignmentRight;
    _soundmarkLabel.font = [UIFont systemFontOfSize:15.0f];
    _soundmarkLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [_soundmarkView addSubview:_soundmarkLabel];
    //音标发音按钮
    _soundButton = [[UIButton alloc] initWithFrame:CGRectMake(w1+10, 0, w2, h)];
    [_soundButton setImage:soundImage forState:UIControlStateNormal];
    [_soundButton addTarget:self action:@selector(soundClick) forControlEvents:UIControlEventTouchUpInside];
    [_soundmarkView addSubview:_soundButton];
    //释义
    CGFloat y3 = hasImage ? 18 : 8;
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_soundmarkView.frame)+y3, WIDTH-50, 12)];
    _detailLabel.text = _word.wordDetail;
    _detailLabel.textAlignment = hasImage ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    _detailLabel.font = [UIFont systemFontOfSize:12.0f];
    _detailLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [self.view addSubview:_detailLabel];
    //若无图片
    if (hasImage) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_detailLabel.frame)+33*603/(HEIGHT-64), WIDTH-50, 0.7)];
        _line.dk_backgroundColorPicker = DKColorPickerWithColors(SEPCOLOR,[UIColor whiteColor],RED);
        [self.view addSubview:_line];
    }else{
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
        _imageView.frame = CGRectMake(25, CGRectGetMaxY(_detailLabel.frame)+30*603/(HEIGHT-64), WIDTH-50, WIDTH-50);
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_word.wordImgUrl]];
        [self.view addSubview:_imageView];
    }
    //若有图片
    //拆分
    CGFloat y4 = hasImage ? CGRectGetMaxY(_detailLabel.frame)+66*603/(HEIGHT-64)+0.7 : CGRectGetMaxY(_detailLabel.frame)+45*603/(HEIGHT-64)+ (WIDTH-50);
    _splitTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, y4, 40, 15)];
    _splitTitleLabel.text = @"拆 分";
    _splitTitleLabel.textColor = GREEN;
    _splitTitleLabel.textAlignment = NSTextAlignmentCenter;
    _splitTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    _splitTitleLabel.layer.masksToBounds = YES;
    _splitTitleLabel.layer.cornerRadius = 3.0f;
    _splitTitleLabel.layer.borderColor = GREEN.CGColor;
    _splitTitleLabel.layer.borderWidth = 1.0f;
    [self.view addSubview:_splitTitleLabel];
    _splitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_splitTitleLabel.frame)+10, y4, WIDTH-CGRectGetMaxX(_splitTitleLabel.frame)-35, 15)];
    _splitLabel.text = _word.wordSplit;
    _splitLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _splitLabel.numberOfLines = 0;
    _splitLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _splitLabel.font = [UIFont systemFontOfSize:13.0f];
    CGRect frame = _splitLabel.frame;
    frame.size.height = [_splitLabel.text boundingRectWithSize:CGSizeMake(WIDTH-CGRectGetMaxX(_splitTitleLabel.frame)-35, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_splitLabel.font,NSFontAttributeName, nil] context:nil].size.height;
    _splitLabel.frame = frame;
    [self.view addSubview:_splitLabel];
    //联想
    _associateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(_splitLabel.frame)+8, 40, 15)];
    _associateTitleLabel.text = @"联 想";
    _associateTitleLabel.textColor = D_BLUE;
    _associateTitleLabel.textAlignment = NSTextAlignmentCenter;
    _associateTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    _associateTitleLabel.layer.masksToBounds = YES;
    _associateTitleLabel.layer.cornerRadius = 3.0f;
    _associateTitleLabel.layer.borderColor = D_BLUE.CGColor;
    _associateTitleLabel.layer.borderWidth = 1.0f;
    [self.view addSubview:_associateTitleLabel];
    _associateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_associateTitleLabel.frame)+10, CGRectGetMaxY(_splitLabel.frame)+6, WIDTH-CGRectGetMaxX(_associateTitleLabel.frame)-35, 15)];
    _associateLabel.numberOfLines = 0;
    _associateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _associateLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _associateLabel.font = [UIFont systemFontOfSize:13.0f];
    _associateLabel.attributedText = [self setColorForString:_word.wordAssociate];
    CGRect frame1 = _associateLabel.frame;
    frame1.size.height = [_associateLabel.attributedText boundingRectWithSize:CGSizeMake(WIDTH-CGRectGetMaxX(_associateTitleLabel.frame)-35, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    _associateLabel.frame = frame1;
    [self.view addSubview:_associateLabel];
    if (_isSub == YES) {
        //上一个
        CGFloat butWidth = (WIDTH - 75)*0.5;
        _preButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _preButton.frame = CGRectMake(25, HEIGHT - 38 - 25*(HEIGHT-64)/603, butWidth, 38);
        [_preButton setTitle:@"上一个" forState:UIControlStateNormal];
        [_preButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _preButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        _preButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _preButton.layer.masksToBounds = YES;
        _preButton.layer.cornerRadius = 6.0f;
        [_preButton addTarget:self action:@selector(preButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_preButton];
        //下一个
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.frame = CGRectMake(50+butWidth, HEIGHT - 38 - 25*(HEIGHT-64)/603, butWidth, 38);
        [_nextButton setTitle:@"下一个" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 6.0f;
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
}
- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 单词读音按钮点击
- (void)soundClick{
    _player  = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:_word.word];//设置语音内容
    utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];//设置语言(英式英语)
    utterance.rate   = 0.5;  //设置语速
    utterance.volume = 1.0;  //设置音量（0.0~1.0）默认为1.0
    utterance.pitchMultiplier    = 1.0;  //设置语调 (0.5-2.0)
    utterance.postUtteranceDelay = 0; //目的是让语音合成器播放下一语句前有短暂的暂停
    [_player speakUtterance:utterance];
}
#pragma mark 给两个"~"之间的字上色
- (NSMutableAttributedString *)setColorForString:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@"~"];
    NSMutableArray *indexArray = [NSMutableArray array];
    for (NSInteger i = 0; i<arr.count; i++) {
        if (i%2==1) {
            NSString *item = arr[i];
            NSString *itemStr = [item substringWithRange:NSMakeRange(0, 1)];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%zd",[str rangeOfString:itemStr].location] forKey:@"loc"];
            [dic setObject:[NSString stringWithFormat:@"%zd",item.length] forKey:@"len"];
            [indexArray addObject:dic];
        }
    }
    NSMutableString *string = [NSMutableString stringWithString:str];
    for (int i= 0; i<string.length; i++) {
        unichar item = [string characterAtIndex:i];
        if (item == '~') {
            [string replaceCharactersInRange:NSMakeRange(i, 1) withString:@" "];
        }
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:RED};
    for (NSMutableDictionary *itemDic in indexArray) {
        NSInteger loc = [itemDic[@"loc"] integerValue];
        NSInteger len = [itemDic[@"len"] integerValue];
        [attrStr addAttributes:dic range:NSMakeRange(loc, len)];
    }
    return attrStr;
}
#pragma mark 上一个
- (void)preButtonClick{
    if (_wordIndex == 0) {
        [YHHud showWithMessage:@"已经是第一个了"];
    }else{
        [self updateUIByWordID:_wordIDArray[_wordIndex-1]];
        _wordIndex--;
    }
}
#pragma mark 下一个
- (void)nextButtonClick{
    if (_wordIndex == _wordIDArray.count-1) {
        [YHHud showWithMessage:@"已经是最后一个了"];
    }else{
        [self updateUIByWordID:_wordIDArray[_wordIndex+1]];
        _wordIndex++;
    }
}
- (void)updateUIByWordID:(NSString *)wordID{
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"id":wordID,@"device_id":DEVICEID};
    [YHWebRequest YHWebRequestForPOST:WORDBYID parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            [self updateUIAndData:json[@"data"]];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud showWithMessage:@"数据请求失败"];
    }];
}
- (void)updateUIAndData:(NSDictionary *)dataDic{
    BOOL hasImage = [dataDic[@"wordImgUrl"] isEqualToString:@""];
    //单词
    _word.word = dataDic[@"word"];
    _wordLabel.frame = CGRectMake(25,  (hasImage ? 78*(HEIGHT-64)/603 : 28)*(HEIGHT-64)/603, WIDTH-50, 22);
    _wordLabel.textAlignment = hasImage ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    _wordLabel.text = dataDic[@"word"];
    //音标
    CGFloat w1 = [dataDic[@"phonogram"] boundingRectWithSize:CGSizeMake(1000, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil] context:nil].size.width;
    UIImage *soundImage = [UIImage imageNamed:@"sound"];
    CGFloat w2 = soundImage.size.width;
    CGFloat h = soundImage.size.height;
    CGFloat x1 = hasImage ? 25 : (WIDTH-w1-w2-10)*0.5;
    CGFloat y2 = hasImage ? 36 : 26;
    _soundmarkView.frame = CGRectMake(x1, CGRectGetMaxY(_wordLabel.frame)+y2*(HEIGHT-64)/603.0, w1+w2+10, h);
    //音标字符串
    _soundmarkLabel.frame = CGRectMake(0, 0, w1, h);
    _soundmarkLabel.text = dataDic[@"phonogram"];
    //音标发音按钮
    _soundButton.frame = CGRectMake(w1+10, 0, w2, h);
    //释义
    _detailLabel.frame = CGRectMake(25, CGRectGetMaxY(_soundmarkView.frame)+(hasImage ? 18 : 8), WIDTH-50, 12);
    _detailLabel.text = dataDic[@"wordDetail"];
    _detailLabel.textAlignment = hasImage ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    //若无图片
    if (_line!=nil) {
        [_line removeFromSuperview];
        _line = nil;
    }
    if (_imageView!=nil) {
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    if (hasImage) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_detailLabel.frame)+33*603/(HEIGHT-64), WIDTH-50, 0.7)];
        _line.dk_backgroundColorPicker = DKColorPickerWithColors(SEPCOLOR,[UIColor whiteColor],RED);
        [self.view addSubview:_line];
    }else{
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
        _imageView.frame = CGRectMake(25, CGRectGetMaxY(_detailLabel.frame)+30*603/(HEIGHT-64), WIDTH-50, WIDTH-50);
        [_imageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"wordImgUrl"]]];
        [self.view addSubview:_imageView];
    }
    //拆分
    CGFloat y4 = hasImage ? CGRectGetMaxY(_detailLabel.frame)+66*603/(HEIGHT-64)+0.7 : CGRectGetMaxY(_detailLabel.frame)+45*603/(HEIGHT-64)+ (WIDTH-50);
    _splitTitleLabel.frame = CGRectMake(25, y4, 40, 15);
    _splitLabel.frame = CGRectMake(CGRectGetMaxX(_splitTitleLabel.frame)+10, y4, WIDTH-CGRectGetMaxX(_splitTitleLabel.frame)-35, 15);
    _splitLabel.text = dataDic[@"wordSplit"];
    CGRect frame = _splitLabel.frame;
    frame.size.height = [_splitLabel.text boundingRectWithSize:CGSizeMake(WIDTH-CGRectGetMaxX(_splitTitleLabel.frame)-35, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_splitLabel.font,NSFontAttributeName, nil] context:nil].size.height;
    _splitLabel.frame = frame;
    //联想
    _associateTitleLabel.frame = CGRectMake(25,CGRectGetMaxY(_splitLabel.frame)+8, 40, 15);
    _associateLabel.frame = CGRectMake(CGRectGetMaxX(_associateTitleLabel.frame)+10, CGRectGetMaxY(_splitLabel.frame)+6, WIDTH-CGRectGetMaxX(_associateTitleLabel.frame)-35, 15);
    _associateLabel.attributedText = [self setColorForString:dataDic[@"wordAssociate"]];
    CGRect frame1 = _associateLabel.frame;
    frame1.size.height = [_associateLabel.attributedText boundingRectWithSize:CGSizeMake(WIDTH-CGRectGetMaxX(_associateTitleLabel.frame)-35, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    _associateLabel.frame = frame1;
}
- (void)returnToLogin{
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
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
