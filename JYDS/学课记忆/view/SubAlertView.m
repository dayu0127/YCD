//
//  SubAlertView.m
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SubAlertView.h"

@implementation SubAlertView

- (instancetype)init{
    self = [super init];
    if (self) {
        _subBtn.layer.borderWidth = 1.0;
        _subBtn.layer.borderColor = DGRAYCOLOR.CGColor;
    }
    return self;
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
