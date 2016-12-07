//
//  BindingNewPhoneVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BindingNewPhoneVC.h"

@interface BindingNewPhoneVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sureButton;
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkButtonClick:(UIButton *)sender;
@end

@implementation BindingNewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _sureButton.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
    for (UITextField *item in _textFieldCollection) {
        //KVC实现改变placeHolder的字体色
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    [_checkButton dk_setTitleColorPicker:DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]) forState:UIControlStateNormal];
}
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)checkButtonClick:(UIButton *)sender {
}
@end
