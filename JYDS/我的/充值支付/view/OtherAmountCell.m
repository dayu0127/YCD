//
//  OtherAmountCell.m
//  JYDS
//
//  Created by liyu on 2017/2/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "OtherAmountCell.h"

@implementation OtherAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self nightModeConfiguration];
}
- (void)nightModeConfiguration{
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _amount.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _money.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
}
- (void)updateConstraints{
    [super updateConstraints];
    _momeyLabelWidth.constant = _momeyLabelWidth.constant + 10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _money.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    _money.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
@end
