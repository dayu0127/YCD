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
            make.center.equalTo(self);
            make.width.height.mas_equalTo(@68);
        }];
        _courseLabel = [UILabel new];
        _courseLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_courseLabel];
        [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}
- (void)setDic:(NSDictionary *)dic{
    [_courseButton setImage:[UIImage imageNamed:dic[@"text"]] forState:UIControlStateNormal];
    _courseLabel.text = dic[@"title"];
}
@end
