//
//  BaseViewController.m
//  YCD
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "BaseViewController.h"
@interface BaseViewController ()
@end
@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)dealloc{
    [self.view endEditing:YES];
}
@end
