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
        _courseButton.layer.cornerRadius = (WIDTH/3.0-56)/2.0;
        _courseButton.titleLabel.font = [UIFont systemFontOfSize:(WIDTH/3.0-56)/3.0];
        _courseButton.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0]; 
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
    [_courseButton setTitle:dic[@"text"] forState:UIControlStateNormal];
    _courseLabel.text = dic[@"title"];
}
@end
