//
//  ResultVC.m
//  JYDS
//
//  Created by liyu on 2017/4/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ResultVC.h"
#import "SuccessView.h"
#import "ResultView.h"
#import "FailedView.h"
#import "ChooseLevelVC.h"
#import "ExerciseVC.h"
@interface ResultVC ()<ExerciseDelegate>
@property (strong,nonatomic) NSMutableArray<UIView *> *viewArray;
@end

@implementation ResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str in _errorNumArray) {
        if (![arr containsObject:str]) {
            [arr addObject:str];
        }
    }
    if (arr.count == 0) {
        SuccessView *successView = [[NSBundle mainBundle] loadNibNamed:@"SuccessView" owner:nil options:nil ].lastObject;
        successView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        successView.delegate = self;
        [self.view addSubview:successView];
    }else if (arr.count>0&&arr.count<10){
        ResultView *resultView = [[ResultView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) imageNameArray:_errorNumArray];
        resultView.delegate = self;
        [self.view addSubview:resultView];
    }else{
        FailedView *failedView = [[NSBundle mainBundle] loadNibNamed:@"FailedView" owner:nil options:nil ].lastObject;
        failedView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        failedView.delegate = self;
        [self.view addSubview:failedView];
    }
}
- (void)backToExerciselView{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ExerciseVC class]]) {
            ExerciseVC *exerciseVC =(ExerciseVC *)controller;
            exerciseVC.level = _level;
            exerciseVC.exerciseCount = _exerciseCount+1;
            [self.navigationController popToViewController:exerciseVC animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initSet" object:nil];
        }
    }
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)backToLevelView{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChooseLevelVC class]]) {
            ChooseLevelVC *chooseLevelVC =(ChooseLevelVC *)controller;
            chooseLevelVC.level = _level;
            [self.navigationController popToViewController:chooseLevelVC animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
