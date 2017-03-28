//
//  NoLoginHeaderView.m
//  JYDS
//
//  Created by liyu on 2017/3/25.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "NoLoginHeaderView.h"
@implementation NoLoginHeaderView
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
        //登录注册按钮
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginButton setTitle:@"登录 / 注册" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.layer.masksToBounds = YES;
        loginButton.layer.cornerRadius = 3.0f;
        loginButton.layer.borderWidth = 1.0f;
        loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [topImageView addSubview:loginButton];
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(@103);
            make.height.mas_equalTo(@33);
        }];
    }
    return self;
}
- (void)loginClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginVC];
    [app.window makeKeyWindow];
}
@end
