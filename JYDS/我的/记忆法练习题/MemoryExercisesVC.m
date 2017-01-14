//
//  MemoryExercisesVC.m
//  JYDS
//
//  Created by liyu on 2016/12/8.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "MemoryExercisesVC.h"
#import "LevelView.h"

@interface MemoryExercisesVC ()<YHAlertViewDelegate,LevelViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (strong,nonatomic) JCAlertView *alertView;

@end
@implementation MemoryExercisesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _beginButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (IBAction)beginButtonClick:(UIButton *)sender {
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"确认练习" message:@"每次练习需要消耗10个学习豆"];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确定练习");//订阅逻辑
        CGFloat y = CGRectGetMaxY(_imageView.frame)+15;
        LevelView *levelView = [[LevelView alloc] initWithFrame:CGRectMake(0, y, WIDTH, HEIGHT-y)];
        levelView.delegate = self;
        [self.view addSubview:levelView];
    }
    [_alertView dismissWithCompletion:nil];
}
- (void)levelButtonClick:(NSInteger)buttonIndex{
    NSLog(@"%zd",buttonIndex);
}
@end
