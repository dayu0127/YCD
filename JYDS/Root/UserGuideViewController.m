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
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) UIButton *entryButton;
@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(WIDTH*3, HEIGHT);
    for (NSInteger i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02zd",i]];
        if (i==2) {
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:self.entryButton];
        }
        [_scrollView addSubview:imageView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = _scrollView.contentOffset.x/WIDTH;
}
- (UIButton *)entryButton{
    if (!_entryButton) {
        _entryButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*0.5-60, HEIGHT - 90, 120, 30)];
        [_entryButton setTitle:@"进入体验" forState:UIControlStateNormal];
        [_entryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _entryButton.backgroundColor = [UIColor whiteColor];
        _entryButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _entryButton.layer.masksToBounds = YES;
        _entryButton.layer.cornerRadius = 5.0f;
        [_entryButton addTarget:self action:@selector(entryRootVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entryButton;
}
- (void)entryRootVC{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginNC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginNC];
    [app.window makeKeyWindow];
}
@end
