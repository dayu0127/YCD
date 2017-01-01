//
//  MnemonicsCell.m
//  JYDS
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsCell.h"
#import "Mnemonics.h"
#import <UIImageView+WebCache.h>

@implementation MnemonicsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _courseName.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _courseTitle.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],[UIColor redColor]);
    _coursePrice.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)updateConstraints{
    [super updateConstraints];
    _coursePriceWidth.constant = _coursePriceWidth.constant + 10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Mnemonics *model = [Mnemonics yy_modelWithJSON:dic];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseImageUrl] placeholderImage:[UIImage imageNamed:@"videoImage"]];
    self.courseName.text = model.courseName;
    self.courseTitle.text = model.courseTitle;
    NSString *coursePrice = @"";
    if ([model.coursePayStatus isEqualToString:@"0"]) {
        if ([model.coursePrice isEqualToString:@"0"]) {
            coursePrice = @"免费";
        }else{
            coursePrice = [NSString stringWithFormat:@"%@学习豆",model.coursePrice];
        }
    }else{
        coursePrice = @"已订阅";
    }
    self.coursePrice.text = coursePrice;
}
@end
