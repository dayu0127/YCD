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
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        topImageView.image = [UIImage imageNamed:@"mine_top"];
        topImageView.userInteractionEnabled = YES;
        [self addSubview:topImageView];
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        loginButton.center = topImageView.center;
        loginButton.bounds = CGRectMake(0, 0, 103, 33);
        [loginButton setTitle:@"登录 / 注册" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.layer.masksToBounds = YES;
        loginButton.layer.cornerRadius = 3.0f;
        loginButton.layer.borderWidth = 1.0f;
        loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [topImageView addSubview:loginButton];
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
