//
//  SuccessView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SuccessView.h"

@implementation SuccessView
- (IBAction)continueClick:(id)sender {
    [_delegate backToLevelView];
}
- (IBAction)backClick:(id)sender {
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    for (UILabel *label in _labelCollection) {
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    _continueButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
@end
