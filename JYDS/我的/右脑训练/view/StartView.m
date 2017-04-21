//
//  StartView.m
//  JYDS
//
//  Created by liyu on 2017/4/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "StartView.h"

@implementation StartView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //logo图片
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_logo"]];
        [self addSubview:logoImageView];
        CGFloat sixHeight = 603.0;
        CGFloat height = HEIGHT-64;
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(102/sixHeight*height);
            make.centerX.equalTo(self);
        }];
        //文字
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"练习题可以帮助你快速掌握编码";
        titleLabel.textColor = DGRAYCOLOR;
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logoImageView.mas_bottom).offset(25/sixHeight*height);
            make.height.mas_equalTo(@16);
            make.centerX.equalTo(self);
        }];
        //编码表按钮
        UIButton *codeListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeListBtn setBackgroundImage:[UIImage imageNamed:@"home_codeBtnBg"] forState:UIControlStateNormal];
        [codeListBtn setTitle:@"编码表" forState:UIControlStateNormal];
        codeListBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [codeListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [codeListBtn addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:codeListBtn];
        [codeListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(107/sixHeight*height);
            make.centerX.equalTo(self);
        }];
        //使用方法按钮
        UIButton *useMethodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [useMethodBtn setBackgroundImage:[UIImage imageNamed:@"home_useMethodBtnBg"] forState:UIControlStateNormal];
        [useMethodBtn setTitle:@"使用方法" forState:UIControlStateNormal];
        useMethodBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [useMethodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [useMethodBtn addTarget:self action:@selector(useClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:useMethodBtn];
        [useMethodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(codeListBtn.mas_bottom).offset(37/sixHeight*height);
            make.centerX.equalTo(self);
        }];
        //进入训练按钮
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"home_enterBtnBg"] forState:UIControlStateNormal];
        [startBtn setTitle:@"进入训练" forState:UIControlStateNormal];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(useMethodBtn.mas_bottom).offset(34/sixHeight*height);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}
- (void)codeClick:(UIButton *)sender{
    [_delegate codeListClick];
}
- (void)useClick:(UIButton *)sender{
    [_delegate useMethodClick];
}
- (void)startClick:(UIButton *)sender{
    [_delegate enterExerciseClick];
}
@end
