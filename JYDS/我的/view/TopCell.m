//
//  TopCell.m
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = D_CELL_SELT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
