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
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        topImageView.image = [UIImage imageNamed:@"mine_top"];
        topImageView.userInteractionEnabled = YES;
        [self addSubview:topImageView];
        //头像
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-67)*0.5, 41, 67, 67)];
        _headImageView.image = [UIImage imageNamed:@"mine_headimage"];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 33.5f;
        [self addSubview:_headImageView];
        //昵称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+13, WIDTH, 14)];
        _nameLabel.text = @"记忆大师";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_nameLabel];
        //电话
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+10, WIDTH, 14)];
        _phoneLabel.text = @"13712345678";
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_phoneLabel];
    }
    return self;
}
@end
