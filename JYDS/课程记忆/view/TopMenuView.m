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
        _contentView = [UIView new];
        [self addSubview:_contentView];
        CGFloat w = [self getW:title];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(@(w+14));
            make.height.mas_equalTo(@13);
        }];
        _titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textColor = DGRAYCOLOR;
        [_contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_contentView);
            make.width.mas_equalTo(@(w));
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"course_drop"]];
        [_contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_contentView.mas_centerY);
            make.right.equalTo(_contentView);
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
- (CGFloat)getW:(NSString *)title{
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0f] forKey:NSFontAttributeName] context:nil].size.width+1;
}
- (void)btnClick:(UIButton *)sender{
    [_delegate menuClick:sender];
}
- (void)updateWidth:(NSString *)title{
    CGFloat w = [self getW:title];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(w+14));
    }];
    _titleLabel.text = title;
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(w));
    }];
}
@end
