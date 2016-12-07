//
//  ForgetPwdVC.m
//  YCD
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "ForgetPwdVC.h"

@interface ForgetPwdVC ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

@end

@implementation ForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITextField *item in _textFieldCollection) {
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UIButton *item in _buttonCollection) {
        [item dk_setTitleColorPicker:DKColorPickerWithRGB(0xffffff,0x000000,0xff0000) forState:UIControlStateNormal];
    }
}
@end
