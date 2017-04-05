//
//  NotSubCell.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "NotSubCell.h"

@implementation NotSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _subBtn.layer.masksToBounds = YES;
    _subBtn.layer.cornerRadius = 2.0f;
    _subBtn.layer.borderColor = [UIColor colorWithRed:0 green:197/255.0 blue:103/255.0 alpha:1.0].CGColor;
    _subBtn.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
