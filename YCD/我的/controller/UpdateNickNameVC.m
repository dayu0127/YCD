//
//  UpdateNickNameVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "UpdateNickNameVC.h"

@interface UpdateNickNameVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sureButton;
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation UpdateNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _sureButton.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
    [_nickNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _nickNameTextField.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    _nickNameTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
