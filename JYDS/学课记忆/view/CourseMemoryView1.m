//
//  CourseMemoryView1.m
//  JYDS
//
//  Created by liyu on 2017/4/4.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "CourseMemoryView1.h"

@implementation CourseMemoryView1
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _courseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_courseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _courseButton.layer.masksToBounds = YES;
        _courseButton.layer.cornerRadius = 34.0f;
        _courseButton.titleLabel.font = [UIFont systemFontOfSize:24.0f];
        _courseButton.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0]; 
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
    [_courseButton setTitle:dic[@"text"] forState:UIControlStateNormal];
    _courseLabel.text = dic[@"title"];
}
@end
