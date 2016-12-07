//
//  MnemonicsCell.m
//  YCD
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsCell.h"

@implementation MnemonicsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _courseTitle.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _courseDetail.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],[UIColor redColor]);
    _studyDouLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
