//
//  RemeberWordSingleWordCell.m
//  YCD
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RemeberWordSingleWordCell.h"

@implementation RemeberWordSingleWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _wordLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _studyDouLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
