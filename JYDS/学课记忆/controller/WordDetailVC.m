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
@interface WordDetailVC ()<UITableViewDataSource,UITableViewDelegate,WordImageCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIImageView *img;
@property (strong,nonatomic) WordImageCell *cell;
@property (strong,nonatomic) UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *phonogramButton;
@property (weak, nonatomic) IBOutlet UILabel *wordExplainLabel;
@property (nonatomic,strong) AVSpeechSynthesizer *player;
@end

@implementation WordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"WordDetailCell" bundle:nil] forCellReuseIdentifier:@"WordDetailCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"WordImageCell" bundle:nil] forCellReuseIdentifier:@"WordImageCell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getFootViewHeight:WIDTH])];//86  140  176
    _wordLabel.text = _word.word;
    [_phonogramButton setTitle:_word.phonogram forState:UIControlStateNormal];
    [_phonogramButton layoutButtonWithEdgeInsetsStyle:YHButtonEdgeInsetsStyleRight imageTitleSpace:8];
    _wordExplainLabel.text = _word.word_explain;
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
        WordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordDetailCell" forIndexPath:indexPath];
        cell.splitOrAssociateLabel.text = _word.split;
        return cell;
    }else if (indexPath.row == 1){
        WordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordDetailCell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:@"course_lian"];
        cell.splitOrAssociateLabel.attributedText = [self setColorForString:_word.associate];
        return cell;
    }else{
        _cell = [tableView dequeueReusableCellWithIdentifier:@"WordImageCell" forIndexPath:indexPath];
        _cell.delegate = self;
        return _cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    _cell.leftSpace.constant = (offsetY+49)/135*82;
    if (_cell.leftSpace.constant >= 112) {
        [self showBottomUI];
    }else{
        //隐藏底部功能界面
        _cell.line.alpha = 0;
        _cell.showButton.alpha = 0;
        _cell.rwButton.alpha = 0;
        if (_cell.leftSpace.constant<=32) {
            _cell.leftSpace.constant=32;
            //显示跟读/跟写按钮
            _cell.readButton.alpha = 1;
            _cell.writeButton.alpha = 1;
        }
    }
    _cell.btnBottomSpace.constant = _cell.frame.size.height - CGRectGetMaxY(_cell.img.frame) + 6;
}
- (void)showReadAndWrite{
    [_tableView setContentOffset:CGPointMake(0,  136)];
    [self showBottomUI];
}
- (void)showBottomUI{
    _cell.leftSpace.constant = 112;
    //显示底部功能界面
    _cell.line.alpha = 1;
    _cell.showButton.alpha = 1;
    _cell.rwButton.alpha = 1;
    //隐藏跟读/跟写按钮
    _cell.readButton.alpha = 0;
    _cell.writeButton.alpha = 0;
}
- (CGFloat)getFootViewHeight:(CGFloat)width{
    CGFloat h = 0;
    if (width==320) {
        h = 86;
    }else if(width==375){
        h = 140;
    }else if(width==414){
        h = 176;
    }
    return h;
}
#pragma mark 显示跟读
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
@end
