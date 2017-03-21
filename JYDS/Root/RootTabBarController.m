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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
    //去除默认状态下UITabBarItem的图标和文字的渲染
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
    //去除tabBar透明化
    self.tabBar.translucent = NO;
    [self nightModeConfiguration];
}
- (void)nightModeConfiguration{
    for (UINavigationController *nav in self.viewControllers) {
        nav.navigationBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        nav.navigationBar.tintColor = [UIColor whiteColor];
    }
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_TABBAR_BG,RED);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        [self dayMode];
    }else{
        [self nightMode];
    }
}
- (void)dayMode{
    CGSize size = CGSizeMake(self.tabBar.bounds.size.width/self.tabBar.items.count, self.tabBar.bounds.size.height);
    //准备绘图环境
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 51/255.0, 153/255.0, 204/255.0, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    //获取该绘图中的图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘图
    UIGraphicsEndImageContext();
    self.tabBar.selectionIndicatorImage = img;
}
- (void)nightMode{
    CGSize size = CGSizeMake(self.tabBar.bounds.size.width/self.tabBar.items.count, self.tabBar.bounds.size.height);
    //准备绘图环境
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 29/255.0, 74/255.0, 143/255.0, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    //获取该绘图中的图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘图
    UIGraphicsEndImageContext();
    self.tabBar.selectionIndicatorImage = img;
}
@end
