//
//  ChooseLevelVC.m
//  JYDS
//
//  Created by liyu on 2017/4/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ChooseLevelVC.h"
#import "LevelView.h"
#import "ExerciseVC.h"
@interface ChooseLevelVC ()<LevelViewDelegate,ExerciseVCDelegate>

@end

@implementation ChooseLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LevelView *levelView = [[LevelView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    levelView.delegate = self;
    [self.view addSubview:levelView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 开始练习
- (void)startExerciseClick:(NSInteger)level{
    _level = level;
    [self performSegueWithIdentifier:@"toExercise" sender:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initSet" object:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toExercise"]) {
        ExerciseVC *exerciseVC = segue.destinationViewController;
        exerciseVC.level = _level;
        exerciseVC.exerciseCount = 1;
        exerciseVC.delegate = self;
    }
}
- (void)setLevel:(NSInteger)level{
    _level = level;
}
@end
