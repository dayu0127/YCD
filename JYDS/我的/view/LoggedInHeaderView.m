//
//  LoggedInHeaderView.m
//  JYDS
//
//  Created by liyu on 2017/3/25.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "LoggedInHeaderView.h"

@implementation LoggedInHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //背景图
        UIImageView *topImageView = [UIImageView new];
        topImageView.image = [UIImage imageNamed:@"mine_top"];
        topImageView.userInteractionEnabled = YES;
        [self addSubview:topImageView];
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //头像
        _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headImageButton setImage:[UIImage imageNamed:@"mine_headimage"] forState:UIControlStateNormal];
        _headImageButton.layer.masksToBounds = YES;
        _headImageButton.layer.cornerRadius = 33.5f;
        [_headImageButton addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headImageButton];
        [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(41);
            make.width.and.height.mas_equalTo(@67);
        }];
        //昵称
        _nameLabel = [UILabel new];
        _nameLabel.text = @"记忆大师";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_headImageButton.mas_bottom).offset(13);
        }];
        //电话
        _phoneLabel = [UILabel new];
        _phoneLabel.text = @"未绑定手机号";
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(@14);
        }];
    }
    return self;
}
- (void)userInfoClick{
    [_delegate pushToUserInfo];
}
@end
