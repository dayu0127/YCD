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
    if (_errorNumArray.count == 0) {
        SuccessView *successView = [[NSBundle mainBundle] loadNibNamed:@"SuccessView" owner:nil options:nil ].lastObject;
        successView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        successView.delegate = self;
        [self.view addSubview:successView];
    }else if (_errorNumArray.count>0&&_errorNumArray.count<10){
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
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSDictionary *dic = @{@"exerciseCount":[NSString stringWithFormat:@"%zd",_exerciseCount+1]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initSet" object:self userInfo:dic];
}
@end
