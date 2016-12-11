//
//  MemoryExercisesVC.m
//  YCD
//
//  Created by liyu on 2016/12/8.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MemoryExercisesVC.h"
#import <JCAlertView.h>
#import "CustomAlertView.h"
@interface MemoryExercisesVC ()<CustomAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (strong,nonatomic) JCAlertView *alertView;

- (IBAction)beginButtonClick:(UIButton *)sender;

@end

@implementation MemoryExercisesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _beginButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
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

- (IBAction)beginButtonClick:(UIButton *)sender {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"确认练习" message:@"每次练习需要消耗10个学习豆"];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确定练习");
    }
    [_alertView dismissWithCompletion:nil];
}
@end
