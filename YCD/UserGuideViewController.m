//
//  UserGuideViewController.m
//  YCD
//
//  Created by dayu on 2016/11/22.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthViewWidth;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*0.5-60, HEIGHT - 100, 120, 30)];
    [enterButton setTitle:@"进入体验" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    enterButton.backgroundColor = [UIColor whiteColor];
    enterButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    enterButton.layer.masksToBounds = YES;
    enterButton.layer.cornerRadius = 5.0f;
    [enterButton addTarget:self action:@selector(enterMainController) forControlEvents:UIControlEventTouchUpInside];
    [self.fourthView addSubview:enterButton];
}
- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant = WIDTH*4;
    self.secondViewWidth.constant = WIDTH;
    self.thirdViewWidth.constant = WIDTH*2;
    self.fourthViewWidth.constant = WIDTH*3;
}
- (void)enterMainController{
    [self performSegueWithIdentifier:@"enterLogin" sender:self];
}
@end
