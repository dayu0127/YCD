//
//  CourseMemoryView.m
//  JYDS
//
//  Created by liyu on 2017/4/4.
//  Copyright © 2017年 dayu. All rights reserved.
//
#import "CourseMemoryView.h"
@implementation CourseMemoryView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _courseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_courseButton];
        [_courseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(25);
            make.left.equalTo(self).offset(28);
            make.right.equalTo(self).offset(-28);
            make.height.mas_equalTo(@(WIDTH/3.0-56));
        }];
        _courseLabel = [UILabel new];
        _courseLabel.font = [UIFont systemFontOfSize:14.0f];
        _courseLabel.textColor = DGRAYCOLOR;
        [self addSubview:_courseLabel];
        [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-12);
        }];
    }
    return self;
}
- (void)setDic:(NSDictionary *)dic{
    [_courseButton setImage:[UIImage imageNamed:dic[@"text"]] forState:UIControlStateNormal];
    _courseLabel.text = dic[@"title"];
}
@end
