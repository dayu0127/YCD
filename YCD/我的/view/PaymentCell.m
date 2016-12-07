//
//  PaymentCell.m
//  YCD
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _title.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
