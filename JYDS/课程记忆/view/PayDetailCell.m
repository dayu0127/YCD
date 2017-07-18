//
//  PayDetailCell.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "PayDetailCell.h"

@implementation PayDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _space1.constant = _space2.constant = _space3.constant = (WIDTH-181)/3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)surePay:(id)sender {
    [_delegate surePayClick];
}
- (IBAction)beanPay:(id)sender {
    [_delegate beanPayClick];
}

@end
