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
    [self nightModeConfiguration];
}
- (void)nightModeConfiguration{
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
    if ([model.payType isEqualToString:@"0"]) {
        self.wordPrice.alpha = 0;
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ios"] isEqualToString:@"0"]) {
            self.wordPrice.alpha = 0;
        }else{
            self.wordPrice.alpha = 1;
            self.wordPrice.text = @"已订阅";
        }
    }
}
@end
