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
    _scrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT);
    for (int i = 0; i<2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d",i+1]];
        if (i==1) {
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
        UIImage *img = [UIImage imageNamed:@"entry"];
        CGFloat w = img.size.width;
        CGFloat h = img.size.height;
        _entryButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-w)*0.5, HEIGHT - 125*HEIGHT/667, w, h)];
        [_entryButton setImage:img forState:UIControlStateNormal];
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
