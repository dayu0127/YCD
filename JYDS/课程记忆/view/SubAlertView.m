//
//  SubAlertView.m
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SubAlertView.h"
#import "UILabel+Utils.h"
@implementation SubAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    for (UILabel *item in _labels) {
        [item setText:item.text lineSpacing:7.0f];
    }
    _subBtn.layer.borderWidth = 1.0;
    _subBtn.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
}


- (instancetype)initWithNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (IBAction)closeViewClick:(UIButton *)sender {
    [_delegate closeClick];
}
- (IBAction)continueSubBtnClick:(UIButton *)sender {
    [_delegate continueSubClick];
}
- (IBAction)invitateFriendBtnClick:(UIButton *)sender {
    [_delegate invitateFriendClick];
}
@end
