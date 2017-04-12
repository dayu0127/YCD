//
//  PlanCell.m
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "PlanCell.h"
#import "UIButton+ImageTitleSpacing.h"
@implementation PlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    for (UIButton *itemButton in _buttonCollection) {
        [itemButton layoutButtonWithEdgeInsetsStyle:YHButtonEdgeInsetsStyleTop imageTitleSpace:8.0f];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)mySubClick:(UIButton *)sender {
    [_delegate pushToMySub];
}
- (IBAction)memoryClick:(UIButton *)sender {
    [_delegate pushToMemoryMore];
}
- (IBAction)invitationClick:(UIButton *)sender {
    [_delegate pushToInvitation];
}
@end
