//
//  WordSearchCell.m
//  JYDS
//
//  Created by liyu on 2017/3/9.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordSearchCell.h"
#import "Words.h"
@implementation WordSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self nightModeConfiguration];
}
- (void)nightModeConfiguration{
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _wordLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subStatusLabel.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
}
- (void)updateConstraints{
    [super updateConstraints];
    _subStatusLabelWidth.constant = _subStatusLabelWidth.constant + 10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _subStatusLabel.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    _subStatusLabel.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Words *model = [Words yy_modelWithJSON:dic];
    self.wordLabel.text = model.word;
    if ([model.payType isEqualToString:@"0"]) {
        self.subStatusLabel.alpha = 0;
    }else{
        self.subStatusLabel.alpha = 1;
        self.subStatusLabel.text = @"已订阅";
    }
}
@end
