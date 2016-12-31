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
}
- (void)updateConstraints{
    [super updateConstraints];
    _wordPriceWidth.constant = _wordPriceWidth.constant + 10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Words *words = [Words yy_modelWithJSON:dic];
    self.word.text = words.word;
    self.wordPrice.text = [NSString stringWithFormat:@"%@学习豆",words.wordPrice];
}
@end
