//
//  UserGuideViewController.m
//  JYDS
//
//  Created by dayu on 2016/11/22.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "UserGuideViewController.h"
#import "LoginNC.h"
#import "AppDelegate.h"
@interface UserGuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) UIButton *entryButton;
@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(WIDTH*3, HEIGHT);
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d",i+1]];
        imageView.userInteractionEnabled = YES;
        if (i!=2) {
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            skipButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [skipButton setTitleColor:ORANGERED forState:UIControlStateNormal];
            skipButton.layer.masksToBounds = YES;
            skipButton.layer.cornerRadius = 9.0f;
            skipButton.layer.borderWidth = 2;
            skipButton.layer.borderColor = ORANGERED.CGColor;
            [skipButton addTarget:self action:@selector(entryRootVC) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:skipButton];
            [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView).offset(33);
                make.right.equalTo(imageView).offset(-10);
                make.width.mas_equalTo(@45);
                make.height.mas_equalTo(@18);
            }];
        }else{
            UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [startButton setTitle:@"开始体验" forState:UIControlStateNormal];
            startButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [startButton setTitleColor:ORANGERED forState:UIControlStateNormal];
            startButton.layer.masksToBounds = YES;
            startButton.layer.cornerRadius = 15.0f;
            startButton.layer.borderWidth = 2;
            startButton.layer.borderColor = ORANGERED.CGColor;
            [startButton addTarget:self action:@selector(entryRootVC) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:startButton];
            [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView);
                make.bottom.equalTo(imageView).offset(-40);
                make.width.mas_equalTo(@109);
                make.height.mas_equalTo(@30);
            }];
        }
        [_scrollView addSubview:imageView];
    }
}

- (void)entryRootVC{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginNC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginNC];
    [app.window makeKeyWindow];
}
@end
