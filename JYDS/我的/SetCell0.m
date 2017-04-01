//
//  SetCell0.m
//  JYDS
//
//  Created by 大雨 on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SetCell0.h"

@implementation SetCell0

- (void)awakeFromNib {
    [super awakeFromNib];
    //右箭头
    _arrows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrows"]];
    [self.contentView addSubview:_arrows];
    [_arrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(@7.5);
        make.height.mas_equalTo(@12.5);
    }];
    //绑定状态
    _bingingLabel = [UILabel new];
    _bingingLabel.text = @"未绑定";
    _bingingLabel.textColor = ORANGERED;
    _bingingLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:_bingingLabel];
    [_bingingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrows).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    //副标题(默认隐藏)
    _titleLabel1 = [UILabel new];
    _titleLabel1.text = @"已绑定";
    _titleLabel1.textColor = MSGEDGECOLOR;
    _titleLabel1.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:_titleLabel1];
    [_titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    _titleLabel1.alpha = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellWithString:(NSString *)str{
    //ps: str表示用户手机号，微信的uid或者QQ的uid
    if ([str isEqualToString:@""]) {
        _arrows.alpha = 1;
        _bingingLabel.alpha = 1;
        _titleLabel1.alpha = 0;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        _arrows.alpha = 0;
        _bingingLabel.alpha = 0;
        _titleLabel1.alpha = 1;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}
@end
