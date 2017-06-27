//
//  ExerciseVC.m
//  JYDS
//
//  Created by liyu on 2017/4/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ExerciseVC.h"
#import "ResultVC.h"
@interface ExerciseVC ()
@property (weak, nonatomic) IBOutlet UILabel *exerciseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *preNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wrongImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) NSTimer *timer1;

@property (assign,nonatomic) NSInteger totalTime;
@property (assign,nonatomic) NSInteger time;
@property (strong,nonatomic) NSMutableArray *errorNumArray;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@end

@implementation ExerciseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSet:) name:@"initSet" object:nil];
    [self initSet:nil];
}
- (void)initSet:(NSNotification *)sender{
    if (sender.userInfo[@"exerciseCount"]!=nil) {
        _exerciseCount = [sender.userInfo[@"exerciseCount"] integerValue];
    }
    _index = 0;
    //初始化错误数字数组
    _errorNumArray = [NSMutableArray array];
    //显示练习次数
    _exerciseCountLabel.text = [NSString stringWithFormat:@"练习次数 %02zd",_exerciseCount];
    //总时间和初始时间
    _totalTime = _time = [LEVELARRAY[_level-1] integerValue];
    //    NSMutableArray *arr = [NSMutableArray array];
    //    for (NSString *str in _errorNumArray) {
    //        if (![arr containsObject:str]) {
    //            [arr addObject:str];
    //        }
    //    }
    //生成不重复的20对 0到00 的数字(0,1,2,...,9,10,11,...,98,99,00)
    _numArray = [NSMutableArray array];
    while(_numArray.count<20){
        int num = arc4random()%101;
        NSString *numStr;
        if (num == 100) {
            numStr = @"00";
        }else{
            numStr = [NSString stringWithFormat:@"%d",num];
        }
        if (![_numArray containsObject:numStr]) {
            [_numArray addObject:numStr];
        }
    }
    //初始时间显示
    [_timeBtn setTitle:[NSString stringWithFormat:@"%@秒",LEVELARRAY[_level-1]] forState:UIControlStateNormal];
    //等级显示
    [_levelBtn setTitle:[NSString stringWithFormat:@"Lv%zd",_level] forState:UIControlStateNormal];
    //错误图片和上一个数字默认隐藏
    _wrongImageView.alpha = 0;
    _preNumLabel.text = @"";
    //当前数字
    _currentNumLabel.text = _numArray[0];
    //下一个数字
    _nextNumLabel.text = _numArray[1];
    //计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _time--;
        [_timeBtn setTitle:[NSString stringWithFormat:@"%zd秒",_time] forState:UIControlStateNormal];
        if (_time == 0) {
            [timer invalidate];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"toResultVC" sender:self];
            });
        }
    }];
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:_totalTime/21.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        _preNumLabel.text = _numArray[_index-1];
//        _wrongImageView.alpha = 0;
//        if (_index<18) {
//            _currentNumLabel.text = _numArray[_index];
//            _nextNumLabel.text = _numArray[_index+1];
//        }else if (_index == 18){
//            _currentNumLabel.text = _numArray[18];
//            _nextNumLabel.text = @"";
//        }else{
//            _currentNumLabel.text = @"";
//            _nextNumLabel.text = @"";
//            [timer invalidate];
//        }
        _wrongImageView.alpha = 0;
        if (_index==0) {
            _forgetButton.enabled = NO;
            _preNumLabel.text = @"";
            _currentNumLabel.text = _numArray[_index];
            _nextNumLabel.text = _numArray[_index+1];
        }else if (_index>0&&_index<19){
            _forgetButton.enabled = YES;
            _preNumLabel.text = _numArray[_index-1];
            _currentNumLabel.text = _numArray[_index];
            _nextNumLabel.text = _numArray[_index+1];
        }else if (_index ==19){
            _preNumLabel.text = _numArray[_index-1];
            _currentNumLabel.text = _numArray[_index];
            _nextNumLabel.text = @"";
        }else if(_index == 20){
            _preNumLabel.text = _numArray[_index-1];
            _currentNumLabel.text = @"";
            _nextNumLabel.text = @"";
            [timer invalidate];
        }
        _index++;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate setLevel:_level];
}
- (IBAction)forgetClick:(id)sender {
    //显示错误图片
    _wrongImageView.alpha = 1;
    //添加错误的数字到数组
    if (![_preNumLabel.text isEqualToString:@""]) {
        [_errorNumArray addObject:_preNumLabel.text];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResultVC"]) {
        ResultVC *resultVC = segue.destinationViewController;
        NSMutableArray *errorNumArray = [NSMutableArray array];
        for (NSString *numStr in _errorNumArray) {
            if (![errorNumArray containsObject:numStr]) {
                [errorNumArray addObject:numStr];
            }
        }
        resultVC.errorNumArray = [NSArray arrayWithArray:errorNumArray];
        resultVC.exerciseCount = _exerciseCount;
        resultVC.level = _level;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    [_timer1 invalidate];
    _timer1 = nil;
}
@end
