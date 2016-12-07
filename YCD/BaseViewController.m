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
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor groupTableViewBackgroundColor],[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0],[UIColor redColor]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
