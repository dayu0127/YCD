//
//  RootTabBarController.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "RootTabBarController.h"
@interface RootTabBarController ()
@end
@implementation RootTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBar.tintColor = [UIColor whiteColor];
    [self nightModeConfiguration];
}
- (void)nightModeConfiguration{
    for (UINavigationController *nav in self.viewControllers) {
        nav.navigationBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        nav.navigationBar.tintColor = [UIColor whiteColor];
    }
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_TABBAR_BG,RED);
}
@end
