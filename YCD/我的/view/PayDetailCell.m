//
//  PayDetailCell.m
//  YCD
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PayDetailCell.h"

@implementation PayDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _paySuccessLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _dateLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],[UIColor redColor]);
    _payMethodLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],[UIColor redColor]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
