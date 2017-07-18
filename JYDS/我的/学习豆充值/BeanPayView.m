//
//  BeanPayView.m
//  JYDS
//
//  Created by liyu on 2017/7/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "BeanPayView.h"

@implementation BeanPayView

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.borderColor = ORANGERED.CGColor;
        self.layer.borderWidth = 1.5f;
        self.layer.cornerRadius = 6.0f;
        CGFloat h = frame.size.height;
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont systemFontOfSize:17.0f];
        _moneyLabel.textColor = ORANGERED;
        [self addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset((h*0.5-17)*0.5);
            make.centerX.equalTo(self);
        }];
        _studyBeanLabel = [UILabel new];
        _studyBeanLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _studyBeanLabel.textColor = DGRAYCOLOR;
        [self addSubview:_studyBeanLabel];
        [_studyBeanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-(h*0.5-12)*0.7);
            make.centerX.equalTo(self);
        }];
        UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
        btn.tag = tag;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)btnClick:(UIButton *)sender{
    [_delegate itemClick:sender.tag];
}
@end
