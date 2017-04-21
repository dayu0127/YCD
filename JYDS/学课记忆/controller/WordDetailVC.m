//
//  WordDetailVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordDetailVC.h"
#import "WordDetailCell.h"
#import "WordImageCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import <AVFoundation/AVFoundation.h>
#import "iflyMSC/iflyMSC.h"
#import "IATConfig.h"
@interface WordDetailVC ()<UITableViewDataSource,UITableViewDelegate,WordImageCellDelegate,IFlyRecognizerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (strong,nonatomic) UIImageView *img;
@property (strong,nonatomic) WordDetailCell *splitCell;
@property (strong,nonatomic) WordDetailCell *associateCell;
@property (strong,nonatomic) WordImageCell *imageCell;
@property (strong,nonatomic) UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *phonogramButton;
@property (weak, nonatomic) IBOutlet UILabel *wordExplainLabel;
@property (nonatomic,strong) AVSpeechSynthesizer *player;
@property (nonatomic,strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) BOOL isStreamRec;//是否是音频流识别
@property (nonatomic,assign) BOOL isBeginOfSpeech;//是否返回BeginOfSpeech回调
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, strong) UIAlertController *alertVC;
@property (strong,nonatomic) UITextField *wordText;
@property (strong,nonatomic) UIAlertAction *sureAction;
@property (assign,nonatomic) BOOL isShowRead;
@property (strong,nonatomic) NSString *classId;
@property (strong,nonatomic) NSString *unitId;

@end

@implementation WordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShowRead = YES;
    _collectButton.alpha = _showCollectButton == YES ? 1 : 0;
    _classId = _word.class_id;
    _unitId = _word.class_id;
    [_tableView registerNib:[UINib nibWithNibName:@"WordDetailCell" bundle:nil] forCellReuseIdentifier:@"WordDetailCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"WordImageCell" bundle:nil] forCellReuseIdentifier:@"WordImageCell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getFootViewHeight])];//86  140  176
    [self loadWordDetail];
}
- (void)loadWordDetail{
    _wordLabel.text = _word.word;
    if ([_word.collectionType integerValue] == 0) {
        [_collectButton setImage:[UIImage imageNamed:@"course_collect"] forState:UIControlStateNormal];
    }else{
        [_collectButton setImage:[UIImage imageNamed:@"course_collected"] forState:UIControlStateNormal];
    }
    [_phonogramButton setTitle:_word.phonogram forState:UIControlStateNormal];
    [_phonogramButton layoutButtonWithEdgeInsetsStyle:YHButtonEdgeInsetsStyleRight imageTitleSpace:8];
    _wordExplainLabel.text = _word.word_explain;
}
- (IBAction)collectionClick:(UIButton *)sender {
    if ([_word.collectionType integerValue] == 0) {//单词收藏
//        {
//            "userPhone":"******"    #用户手机号
//            "token":"****"          #登陆凭证
//            "unitId"："****"         #单元id
//            "classId"："****"        #课本id
//            "wordId":"**"           #单词id
//        }
        NSDictionary *jsonDic = @{@"classId":_word.class_id,    //  #版本ID
                                  @"unitId" :_word.unit_id,    // #单元ID
                                  @"wordId":_word.wordId,         //  #当前页数
                                  @"userPhone":self.phoneNum,     //  #用户手机号
                                  @"token":self.token};       //   #登陆凭证
        [YHWebRequest YHWebRequestForPOST:kCollectionWord parameters:jsonDic success:^(NSDictionary *json) {
            if([json[@"code"] integerValue] == 200){
                //刷新单词收藏图片
                [sender setImage:[UIImage imageNamed:@"course_collected"] forState:UIControlStateNormal];
                _word.collectionType = @"1";
                if (_isMyCollect == YES) {
                    [_delegate updateMyCollectList];
                }else{
                    [_delegate updateWordList];
                }
                [YHHud showWithMessage:@"收藏成功"];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{//单词取消收藏
//        {
//            "userPhone":"******"    #用户手机号
//            "token":"****"          #登陆凭证
//            "unitId"："****"         #单元id
//            "classId"："****"        #课本id
//            "wordId":"**"           #单词id
//        }
        NSDictionary *jsonDic = @{@"classId":_word.class_id,    //  #版本ID
                                  @"unitId" :_word.unit_id,    // #单元ID
                                  @"wordId":_word.wordId,         //  #当前页数
                                  @"userPhone":self.phoneNum,     //  #用户手机号
                                  @"token":self.token};       //   #登陆凭证
        [YHWebRequest YHWebRequestForPOST:kCancelCollectionWord parameters:jsonDic success:^(NSDictionary *json) {
            if([json[@"code"] integerValue] == 200){
                //刷新单词收藏图片
                [sender setImage:[UIImage imageNamed:@"course_collect"] forState:UIControlStateNormal];
                _word.collectionType = @"0";
                if (_isMyCollect == YES) {
                    [_delegate updateMyCollectList];
                }else{
                    [_delegate updateWordList];
                }
                [YHHud showWithMessage:@"已取消收藏"];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
#pragma mark 单词读音按钮点击
- (IBAction)phonogramButtonClick:(UIButton *)sender {
    _player  = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:_word.word];//设置语音内容
    utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];//设置语言(英式英语)
    utterance.rate   = 0.5;  //设置语速
    utterance.volume = 1.0;  //设置音量（0.0~1.0）默认为1.0
    utterance.pitchMultiplier    = 1.0;  //设置语调 (0.5-2.0)
    utterance.postUtteranceDelay = 0; //目的是让语音合成器播放下一语句前有短暂的暂停
    [_player speakUtterance:utterance];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=2) {
        return 82;
    }else{
        return (WIDTH-80)*(240/295.0)+76;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _splitCell = [tableView dequeueReusableCellWithIdentifier:@"WordDetailCell" forIndexPath:indexPath];
        _splitCell.splitOrAssociateLabel.text = _word.split;
        return _splitCell;
    }else if (indexPath.row == 1){
        _associateCell = [tableView dequeueReusableCellWithIdentifier:@"WordDetailCell" forIndexPath:indexPath];
        _associateCell.img.image = [UIImage imageNamed:@"course_lian"];
        _associateCell.splitOrAssociateLabel.attributedText = [self setColorForString:_word.associate];
        return _associateCell;
    }else{
        _imageCell = [tableView dequeueReusableCellWithIdentifier:@"WordImageCell" forIndexPath:indexPath];
        [_imageCell.preBtn addTarget:self action:@selector(preBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageCell.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageCell setModel:_word];
        _imageCell.delegate = self;
        return _imageCell;
    }
}
#pragma mark 上一个点击事件
- (void)preBtnClick:(UIButton *)sender{
    _indexOfWord--;
    [self reloadWordDeltail:_indexOfWord];
}
#pragma mark 下一个点击事件
- (void)nextBtnClick:(UIButton *)sender{
    _indexOfWord++;
    [self reloadWordDeltail:_indexOfWord];
}
- (void)reloadWordDeltail:(NSInteger)wordIndex{
    //    {
    //        "userPhone":"******"        #用户手机号
    //        "pageIndex":1               #下标
    //        "token":""                  #用户登陆凭证
    //        "classId":""                #课本id
    //        "unitId":""                 #单元id
    //    }
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,         //#用户手机号
        @"pageIndex":[NSString stringWithFormat:@"%zd",wordIndex],                   //#下标
        @"token":self.token,                    //#用户登陆凭证
        @"classId":_classId,                  //#课本id
        @"unitId":_unitId                     //#单元id
    };
    NSLog(@"%@",jsonDic);
    [YHWebRequest YHWebRequestForPOST:kWordFlip parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _word = [Word yy_modelWithJSON:jsonDic[@"word"]];
            [self loadWordDetail];
            _splitCell.splitOrAssociateLabel.text = _word.split;
            _associateCell.splitOrAssociateLabel.attributedText = [self setColorForString:_word.associate];
            [_imageCell setModel:_word];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    _imageCell.leftSpace.constant = (offsetY+49)/135*82;
    if (_imageCell.leftSpace.constant >= 112) {
        [self showBottomUI];
    }else{
        //隐藏底部功能界面
        _imageCell.line.alpha = 0;
        _imageCell.showButton.alpha = 0;
        _imageCell.rwButton.alpha = 0;
        //删除跟读(跟写)点击事件
        if (_isShowRead) {
            [_imageCell.rwButton removeTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_imageCell.rwButton removeTarget:self action:@selector(writeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (_imageCell.leftSpace.constant<=32) {
            _imageCell.leftSpace.constant=32;
            //显示跟读/跟写按钮
            _imageCell.readButton.alpha = 1;
            _imageCell.writeButton.alpha = 1;
        }
    }
    _imageCell.btnBottomSpace.constant = _imageCell.frame.size.height - CGRectGetMaxY(_imageCell.img.frame) + 6;
}
#pragma mark 单词跟读代理
- (void)showRead{
    _isShowRead = YES;
    [self showBottomUI];
    [_imageCell.showButton setTitle:@"" forState:UIControlStateNormal];
    [_imageCell.showButton setImage:[UIImage imageNamed:@"course_volume"] forState:UIControlStateNormal];
    _imageCell.rwButton.backgroundColor = [UIColor colorWithRed:131/255.0 green:46/255.0 blue:43/255.0 alpha:1.0];
    [_imageCell.rwButton setTitle:@"跟读" forState:UIControlStateNormal];
    //删除跟写点击事件
    [_imageCell.rwButton removeTarget:self action:@selector(writeClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加跟读点击事件
    [_imageCell.rwButton addTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 单词跟写代理
- (void)showWrite{
    _isShowRead = NO;
    [self showBottomUI];
    [_imageCell.showButton setImage:nil forState:UIControlStateNormal];
    _imageCell.rwButton.backgroundColor = ORANGERED;
    [_imageCell.rwButton setTitle:@"跟写" forState:UIControlStateNormal];
    //删除跟读点击事件
    [_imageCell.rwButton removeTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加跟写点击事件
    [_imageCell.rwButton addTarget:self action:@selector(writeClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)showBottomUI{
     [_tableView setContentOffset:CGPointMake(0,  136)];
    _imageCell.leftSpace.constant = 112;
    //显示底部功能界面
    _imageCell.line.alpha = 1;
    _imageCell.showButton.alpha = 1;
    _imageCell.rwButton.alpha = 1;
    //添加跟读(跟写)点击事件
    if (_isShowRead == YES) {
        [_imageCell.rwButton addTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_imageCell.rwButton addTarget:self action:@selector(writeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //隐藏跟读/跟写按钮
    _imageCell.readButton.alpha = 0;
    _imageCell.writeButton.alpha = 0;
}
- (CGFloat)getFootViewHeight{
    CGFloat h = 0;
    if (WIDTH==320) {
        h = 86;
    }else if(WIDTH==375){
        h = 140;
    }else if(WIDTH==414){
        h = 176;
    }
    return h;
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark 跟读点击事件
- (void)readClick:(UIButton *)sender{
    if(_iflyRecognizerView == nil){
        [self initRecognizer];
    }
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动服务
    [_iflyRecognizerView start];
}
#pragma mark 跟写点击事件
- (void)writeClick:(UIButton *)sender{
    _alertVC = [UIAlertController alertControllerWithTitle:nil message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
    //单词输入框
    _wordText = [UITextField new];
    _wordText.borderStyle = UITextBorderStyleRoundedRect;
    [_wordText addTarget:self action:@selector(nickEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    _wordText.placeholder = @"请输入";
    [_alertVC.view addSubview:_wordText];
    [_wordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertVC.view).offset(50);
        make.centerX.mas_equalTo(_alertVC.view.mas_centerX);
        make.width.mas_equalTo(@250);
        make.height.mas_equalTo(@38);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    _sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_imageCell.showButton setTitle:_wordText.text forState:UIControlStateNormal];
        if ([[_wordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:_word.word]) {
            [YHHud showRightOrWrong:@"right"];
        }else{
            [YHHud showRightOrWrong:@"wrong"];
        }
    }];
    _sureAction.enabled = NO;
    [_alertVC addAction:cancel];
    [_alertVC addAction:_sureAction];
    [self presentViewController:_alertVC animated:YES completion:nil];
}
- (void)nickEditingChanged:(UITextField *)sender{
    NSString *resultStr = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([resultStr isEqualToString:@""]) {
        _sureAction.enabled = NO;
    }else{
        _sureAction.enabled = YES;
    }
}
#pragma mark 设置识别参数
-(void)initRecognizer{
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示剧中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iflyRecognizerView.delegate = self;
    if (_iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"5000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    }
}
/**
 *听写结束回调（注：无论听写是否正确都会回调）
 *error.errorCode =
 *0     听写正确
 *other 听写出错
 */
- (void)onError:(IFlySpeechError *) error{
    NSLog(@"%s",__func__);
    NSLog(@"errorCode:%d",[error errorCode]);
}
/**
 *有界面，听写结果回调
 *resultArray：听写结果
 *isLast：表示最后一次
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    if (![result isEqualToString:@""]) {
        //添加背景
        NSString *message = [NSString stringWithFormat:@"%@",result];
        UIView *hud = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        //添加提示框
        CGFloat width =[message boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0f] forKey:NSFontAttributeName] context:nil].size.width+24;
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, width, 40)];
        messageLabel.center = hud.center;
        //    messageLabel.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BLUE,RED);
        messageLabel.backgroundColor = ORANGERED;
        messageLabel.text = message;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        //    messageLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        messageLabel.textColor = [UIColor whiteColor];
        [hud addSubview:messageLabel];
        messageLabel.layer.masksToBounds = YES;
        messageLabel.layer.cornerRadius = 6.0f;
        //视图消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];
            if ([[message lowercaseString] isEqualToString:_word.word]) {
                [YHHud showRightOrWrong:@"right"];
            }else{
                [YHHud showRightOrWrong:@"wrong"];
            }
        });
    }
}
@end
