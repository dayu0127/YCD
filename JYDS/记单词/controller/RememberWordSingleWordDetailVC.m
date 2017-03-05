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
@interface RememberWordSingleWordDetailVC ()
@property (nonatomic,strong) AVSpeechSynthesizer *player;
@end

@implementation RememberWordSingleWordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:@"单词详情"];
    self.leftBarButton.hidden = NO;
    //单词
    UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 64+58*(HEIGHT-64)/603, WIDTH-50, 22)];
    wordLabel.text = _word.word;
    wordLabel.dk_textColorPicker = DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED);
    wordLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    wordLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:wordLabel];
    //音标
    UILabel *soundmarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(wordLabel.frame)+28*(HEIGHT-64)/603.0, WIDTH*0.5-25-4, 12)];
    soundmarkLabel.text = _word.phonogram;
    soundmarkLabel.textAlignment = NSTextAlignmentRight;
    soundmarkLabel.font = [UIFont systemFontOfSize:12.0f];
    soundmarkLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [self.view addSubview:soundmarkLabel];
    //音标发音按钮
    UIImage *soundImage = [UIImage imageNamed:@"sound"];
    UIButton *soundButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*0.5+4, soundmarkLabel.center.y-soundImage.size.height*0.5, soundImage.size.width, soundImage.size.height)];
    [soundButton setImage:soundImage forState:UIControlStateNormal];
    [soundButton addTarget:self action:@selector(soundClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundButton];
    //释义
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(soundButton.frame)+8, WIDTH-50, 12)];
    detailLabel.text = _word.wordDetail;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont systemFontOfSize:12.0f];
    detailLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [self.view addSubview:detailLabel];
    //图片(若有)
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(detailLabel.frame)+20*603/(HEIGHT-64), WIDTH-50, (WIDTH-50)*9/16.0)];
    imageView.image = [UIImage imageNamed:@"banner"];
    [self.view addSubview:imageView];
    //拆分
    UILabel *splitTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(imageView.frame)+10, 40, 15)];
    splitTitleLabel.text = @"拆 分";
    splitTitleLabel.textColor = GREEN;
    splitTitleLabel.textAlignment = NSTextAlignmentCenter;
    splitTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    splitTitleLabel.layer.masksToBounds = YES;
    splitTitleLabel.layer.cornerRadius = 3.0f;
    splitTitleLabel.layer.borderColor = GREEN.CGColor;
    splitTitleLabel.layer.borderWidth = 1.0f;
    [self.view addSubview:splitTitleLabel];
    UILabel *splitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(splitTitleLabel.frame)+10, CGRectGetMaxY(imageView.frame)+10, WIDTH-CGRectGetMaxX(splitTitleLabel.frame)-35, 15)];
    splitLabel.text = _word.wordSplit;
    splitLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    splitLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:splitLabel];
    //联想
    UILabel *associateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(splitTitleLabel.frame)+8, 40, 15)];
    associateTitleLabel.text = @"联 想";
    associateTitleLabel.textColor = D_BLUE;
    associateTitleLabel.textAlignment = NSTextAlignmentCenter;
    associateTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    associateTitleLabel.layer.masksToBounds = YES;
    associateTitleLabel.layer.cornerRadius = 3.0f;
    associateTitleLabel.layer.borderColor = D_BLUE.CGColor;
    associateTitleLabel.layer.borderWidth = 1.0f;
    [self.view addSubview:associateTitleLabel];
    UILabel *associateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(associateTitleLabel.frame)+10, CGRectGetMaxY(splitTitleLabel.frame)+8, WIDTH-CGRectGetMaxX(associateTitleLabel.frame)-35, 15)];
    associateLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    associateLabel.font = [UIFont systemFontOfSize:13.0f];
    associateLabel.attributedText = [self setColorForString:_word.wordAssociate];
    [self.view addSubview:associateLabel];
    //上一个
//    UIButton *preButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-200)*0.5, CGRectGetMaxY(associateLabel.frame)+57*(HEIGHT-64)/603, 200, 38)];
//    [preButton setTitle:@"上一个" forState:UIControlStateNormal];
//    [preButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    preButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    preButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    preButton.layer.masksToBounds = YES;
//    preButton.layer.cornerRadius = 6.0f;
//    [preButton addTarget:self action:@selector(preButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:preButton];
//    //下一个
//    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-200)*0.5, CGRectGetMaxY(preButton.frame)+10, 200, 38)];
//    [nextButton setTitle:@"下一个" forState:UIControlStateNormal];
//    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    nextButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
//    nextButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    nextButton.layer.masksToBounds = YES;
//    nextButton.layer.cornerRadius = 6.0f;
//    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:nextButton];
}
#pragma mark 单词读音按钮点击
- (void)soundClick{
    _player  = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:_word.word];//设置语音内容
    utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];//设置语言(英式英语)
    utterance.rate   = 0.5;  //设置语速
    utterance.volume = 1.0;  //设置音量（0.0~1.0）默认为1.0
    utterance.pitchMultiplier    = 1.0;  //设置语调 (0.5-2.0)
    utterance.postUtteranceDelay = 1; //目的是让语音合成器播放下一语句前有短暂的暂停
    [_player speakUtterance:utterance];
}
#pragma mark 给两个"~"之间的字上色
- (NSMutableAttributedString *)setColorForString:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@"~"];
    NSString *str0 = arr[0];
    NSString *str1 = arr[1];
    NSUInteger loc = 0;
    if ([@"" isEqualToString:str0]) {
        loc = 1;
    }else{
        loc = str0.length+1;
    }
    NSUInteger len = str1.length;
    NSMutableString *string = [NSMutableString stringWithString:str];
    for (int i= 0; i<string.length; i++) {
        unichar item = [string characterAtIndex:i];
        if (item == '~') {
            [string replaceCharactersInRange:NSMakeRange(i, 1) withString:@" "];
        }
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:D_BLUE};
    [attrStr addAttributes:dic range:NSMakeRange(loc, len)];
    return attrStr;
}
#pragma mark 上一个
- (void)preButtonClick{
    NSLog(@"上一个");
}
#pragma mark 下一个
- (void)nextButtonClick{
    NSLog(@"下一个");
}
@end
