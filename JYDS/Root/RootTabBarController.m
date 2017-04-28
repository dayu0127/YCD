//
//  RootTabBarController.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "RootTabBarController.h"
#import "LoginNC.h"
@interface RootTabBarController ()
@end
@implementation RootTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBar.tintColor = [UIColor whiteColor];
    for (UINavigationController *nav in self.viewControllers) {
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationBar.translucent = NO;
    }
    //去除默认状态下UITabBarItem的图标和文字的渲染
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:240/255.0 green:178/255.0 blue:164/255.0 alpha:1.0]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:ORANGERED} forState:UIControlStateSelected];
    }
    [self.tabBar setClipsToBounds:YES];
}
@end
