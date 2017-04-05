//
//  TopMenuView.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "TopMenuView.h"

@implementation TopMenuView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = DGRAYCOLOR;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(18);
            make.left.equalTo(self).offset(33/125.0*(WIDTH/3.0));
            make.height.mas_equalTo(@13);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"course_drop"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(22);
            make.left.equalTo(self).offset(67/125.0*(WIDTH/3.0));
            make.width.mas_equalTo(@11);
            make.height.mas_equalTo(@6);
        }];
        self.userInteractionEnabled = YES;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        btn.tag = tag;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)btnClick:(UIButton *)sender{
    [_delegate menuClick:sender.tag];
}
@end
