//
//  BindingNewPhoneVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BindingNewPhoneVC.h"

@interface BindingNewPhoneVC ()


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)sureButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@end

@implementation BindingNewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITextField *item in _textFieldCollection) {
        //KVC实现改变placeHolder的字体色
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UIView *line in _lineCollection) {
        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    }
    _checkButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _sureButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (IBAction)checkButtonClick:(UIButton *)sender {
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
