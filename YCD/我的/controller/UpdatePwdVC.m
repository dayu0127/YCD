//
//  UpdatePwdVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "UpdatePwdVC.h"
@interface UpdatePwdVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sureButton;
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@end
@implementation UpdatePwdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _sureButton.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
    for (UITextField *item in _textFieldCollection) {
        //KVC实现改变placeHolder的字体色
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
}
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
