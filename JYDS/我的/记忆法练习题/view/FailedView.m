//
//  FailedView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "FailedView.h"

@implementation FailedView
- (IBAction)continueClick:(id)sender {
    [_delegate backToExerciselView];
}
- (IBAction)backClick:(id)sender {
    [_delegate backToLevelView];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    for (UILabel *label in _labelCollection) {
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    _continueButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (void)updateConstraints{
    [super updateConstraints];
    _topHeight.constant = self.frame.size.height*100/603.0;
    _verticalSpacing1.constant = self.frame.size.height*22/603.0;
    _verticalSpacing2.constant = self.frame.size.height*30/603.0;
    _verticalSpacing3.constant =self.frame.size.height*14/603.0;
    _buttomHeight.constant = self.frame.size.height*73/603.0;
}
@end
