//
//  RootTabBarController.m
//  YCD
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
    for (UINavigationController *nav in self.viewControllers) {
        nav.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
        nav.navigationBar.dk_tintColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor],[UIColor redColor]);
    }
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    self.tabBar.dk_tintColorPicker = DKColorPickerWithColors([UIColor orangeColor],[UIColor whiteColor],[UIColor redColor]);
}
@end
