//
//  BaseCell.m
//  JYDS
//
//  Created by liyu on 2017/4/25.
//  Copyright © 2017年 dayu. All rights reserved.
//
#import "BaseCell.h"
@implementation BaseCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = kCellBg;
}
@end
