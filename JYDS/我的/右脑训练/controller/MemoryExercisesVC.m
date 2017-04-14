//
//  MemoryExercisesVC.m
//  JYDS
//
//  Created by liyu on 2016/12/8.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "MemoryExercisesVC.h"
#import "LevelView.h"
#import "ExerciseView.h"
#import "SuccessView.h"
#import "ResultView.h"
#import "FailedView.h"
//#import "PayVC.h"

@interface MemoryExercisesVC ()</*YHAlertViewDelegate,*/LevelViewDelegate,ExerciseViewDelegate,SuccessViewDelegate,FailedViewDelegate,ResultViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UILabel *useTitle;
@property (weak, nonatomic) IBOutlet UITextView *useTextView;
@property (strong,nonatomic) LevelView *levelView;
@property (strong,nonatomic) NSMutableArray *errorNumArray;
@property (strong,nonatomic) ExerciseView *exerciseView;
@property (strong,nonatomic) SuccessView *successView;
@property (strong,nonatomic) ResultView *resultView;
@property (strong,nonatomic) FailedView *failedView;
@property (assign,nonatomic) NSInteger exerciseNum;
@property (assign,nonatomic) NSInteger currentLevel;

@end
@implementation MemoryExercisesVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
//    _beginButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _useTitle.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _useTextView.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _errorNumArray = [NSMutableArray array];
    _exerciseNum = 1;
//    [YHWebRequest YHWebRequestForPOST:GAME parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            if ([json[@"payType"] integerValue] == 1) {
//                [self initLevelView];
//            }
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"数据异常"];
//        }
//    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 开始练习
- (IBAction)beginButtonClick:(UIButton *)sender {
//    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"确认练习" message:@"每次练习需要消耗10个学习豆"];
//    alertView.delegate = self;
//    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
//    [_alertView show];
    [self initLevelView];
}
- (void)initLevelView{
    CGFloat y = CGRectGetMaxY(_imageView.frame)+15;
    _levelView = [[LevelView alloc] initWithFrame:CGRectMake(0, y, WIDTH, HEIGHT-y)];
    _levelView.delegate = self;
    [self.view addSubview:_levelView];
}
#pragma mark 确认订阅
//- (void)buttonClickIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        if (20>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
//            [YHHud showWithMessage:@"您的学习豆不足，请充值"];
//        }else{
//            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"payStudyBean":@"20",@"type":@"game"};
//            [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary *json) {
//                if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBean" object:nil];
//                    [YHHud showWithSuccess:@"订阅成功"];
//                    [self initLevelView];
//                }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                    [YHHud showWithMessage:@"服务器错误"];
//                }else{
//                    [YHHud showWithMessage:@"订阅失败"];
//                }
//            }];
//        }
//    }
//    [_alertView dismissWithCompletion:nil];
//}
#pragma mark 选择等级
- (void)levelButtonClick:(NSInteger)buttonIndex{
    _currentLevel = buttonIndex;
    _exerciseView = [[ExerciseView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) ExerciseNum:1 level:buttonIndex];
    _exerciseView.delegate = self;
    [self.view addSubview:_exerciseView];
}
#pragma mark 记录记不住的数字
- (void)passClick:(NSString *)errorNum{
    [_errorNumArray addObject:errorNum];
}
- (void)showResultView{
    [_exerciseView removeFromSuperview];
    _exerciseView = nil;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str in _errorNumArray) {
        if (![arr containsObject:str]) {
            [arr addObject:str];
        }
    }
    if (arr.count == 0) {
        _successView = [[NSBundle mainBundle] loadNibNamed:
                        @"SuccessView" owner:nil options:nil ].lastObject;
        _successView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _successView.delegate = self;
        [self.view addSubview:_successView];
    }else if (arr.count>0&&arr.count<10){
        _resultView = [[ResultView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) imageNameArray:arr];
        _resultView.delegate = self;
        [self.view addSubview:_resultView];
    }else{
        _failedView = [[NSBundle mainBundle] loadNibNamed:
                        @"FailedView" owner:nil options:nil ].lastObject;
        _failedView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _failedView.delegate = self;
        [self.view addSubview:_failedView];
    }
}
- (void)backToLevelView{
    [_errorNumArray removeAllObjects];
    if (_successView!=nil) {
        [_successView removeFromSuperview];
        _successView = nil;
    }
    if (_failedView!=nil) {
        [_failedView removeFromSuperview];
        _failedView = nil;
    }
    if (_resultView!=nil) {
        [_resultView removeFromSuperview];
        _resultView = nil;
    }
}
- (void)backToExerciselView{
    [self backToLevelView];
    _exerciseView = [[ExerciseView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) ExerciseNum:_exerciseNum+1 level:_currentLevel];
    _exerciseView.delegate = self;
    [self.view addSubview:_exerciseView];
}
@end
