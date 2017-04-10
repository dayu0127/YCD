//
//  SureSubView.m
//  testDemo
//
//  Created by 大雨 on 2017/4/9.
//  Copyright © 2017年 大雨. All rights reserved.
//

#import "SureSubView.h"

@implementation SureSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [_delegate cancelClick];
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    [_delegate sureClick];
}

@end
