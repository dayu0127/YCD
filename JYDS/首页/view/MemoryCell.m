//
//  MemoryCell.m
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryCell.h"

@implementation MemoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageBgView.layer.masksToBounds = YES;
    _imageBgView.layer.borderColor = LINECOLOR.CGColor;
    _imageBgView.layer.borderWidth = 1.0f;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_memoryDetail.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_memoryDetail.text length])];
    [_memoryDetail setAttributedText:attributedString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
