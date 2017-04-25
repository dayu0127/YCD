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
#import "StartView.h"
@interface MemoryExercisesVC ()<StartViewDelegate>

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
    StartView *startView = [[StartView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    startView.delegate = self;
    [self.view addSubview:startView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 编码表
- (void)codeListClick{
    [self performSegueWithIdentifier:@"toCodeList" sender:self];
}
- (void)useMethodClick{
    [self performSegueWithIdentifier:@"toUseMethod" sender:self];
}
#pragma mark 进入训练
- (void)enterExerciseClick{
    [self performSegueWithIdentifier:@"toChooseLevel" sender:self];
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
@end
