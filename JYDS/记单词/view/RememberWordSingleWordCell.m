//
//  RememberWordSingleWordCell.m
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordSingleWordCell.h"
#import "Words.h"

@implementation RememberWordSingleWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _word.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _wordPrice.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
}
- (void)updateConstraints{
    [super updateConstraints];
    _wordPriceWidth.constant = _wordPriceWidth.constant + 10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _wordPrice.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    _wordPrice.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Words *model = [Words yy_modelWithJSON:dic];
    self.word.text = model.word;
    NSString *wordPrice = @"";
    if ([model.payType isEqualToString:@"0"]) {
        wordPrice = [NSString stringWithFormat:@"%@学习豆",model.wordPrice];
    }else{
        if ([model.wordPrice isEqualToString:@"0"]) {
            wordPrice = @"免费";
        }else{
            wordPrice = @"已订阅";
        }
    }
    self.wordPrice.text = wordPrice;
}
@end
