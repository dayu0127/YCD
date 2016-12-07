//
//  LoginNC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "LoginNC.h"

@interface LoginNC ()

@end

@implementation LoginNC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.dk_tintColorPicker = DKColorPickerWithRGB(0x000000,0xffffff,0xff0000);
    self.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
