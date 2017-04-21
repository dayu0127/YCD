//
//  LevelView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "LevelView.h"

@implementation LevelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _buttonArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"请选择难度等级";
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.textColor = DGRAYCOLOR;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(31);
            make.height.mas_equalTo(@18);
            make.centerX.equalTo(self);
        }];
        
        //等级按钮
        CGFloat diameter = (WIDTH-112)/3.0;
        for (NSInteger i = 0; i< 3; i++) {
            CGFloat y = 79+(diameter+35)*i;
            for (NSInteger j = 0; j<3; j++) {
                CGFloat x = 31+(diameter+25)*j;
                UIButton *levelBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, diameter, diameter)];
                levelBtn.tag = i*3+j;
                NSString *imageStr = [NSString stringWithFormat:@"Lv%zd",i*3+j+1];
                [levelBtn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
                [levelBtn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
                [self addSubview:levelBtn];
                [_buttonArray addObject:levelBtn];
            }
        }
        //开始练习
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"start_bg"] forState:UIControlStateNormal];
        [startBtn setTitle:@"开始练习" forState:UIControlStateNormal];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(WIDTH+89);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}
- (void)btnTouchDown:(UIButton *)sender{
    for (NSInteger i = 1; i<=_buttonArray.count; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"Lv%zd",i];
        UIButton *btn = (UIButton *)[_buttonArray objectAtIndex:i-1];
        [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
    _currentLevel = sender.tag+1;
    NSString *currentImageStr = [NSString stringWithFormat:@"Lv%zd_selected",sender.tag+1];
    [sender setBackgroundImage:[UIImage imageNamed:currentImageStr] forState:UIControlStateNormal];
}
- (void)startClick:(UIButton *)sender{
    if (_currentLevel == 0) {
        [YHHud showWithMessage:@"请先选择难度等级"];
    }else{
        [_delegate startExerciseClick:_currentLevel];
    }
}
@end
