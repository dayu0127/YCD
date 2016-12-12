//
//  UpdateNickNameVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "UpdateNickNameVC.h"

@interface UpdateNickNameVC ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
- (IBAction)sureButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation UpdateNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _sureButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    [_nickNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _nickNameTextField.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    _nickNameTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (IBAction)nickNameText:(UITextField *)sender {
    if (sender.text.length == 0) {
        _sureButton.enabled = NO;
        _sureButton.backgroundColor = [UIColor lightGrayColor];
    }else if(sender.text.length > 0 && sender.text.length <= 12){
        _sureButton.enabled = YES;
        _sureButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    }else{
        sender.text = [sender.text substringToIndex:12];
    }
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    if (REGEX(NICK_RE, _nickNameTextField.text)==NO) {
        ALERT_SHOW(@"只能是数字,字母,下划线和汉字哦");
    }else{
        NSLog(@"修改成功");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
