//
//  GradeCell.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "GradeCell.h"
#import "Version.h"
#import <UIImageView+WebCache.h>
@implementation GradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Version *v = [Version yy_modelWithJSON:dic];
//    \"id\": \"7920306d0f6b11e7a51c02004c4f4f50\",
//    \"class_name\": \"牛津上海版\",
//    \"total_words\": 172,
//    \"full_price\": 3600.00,
//    \"imgurl\": \"0\",
//    \"payType\": \"0\"
    _classNameLabel.text = v.class_name;
    _gradeNameLabel.text = v.grade_name;
    _totalWordLabel.text = [NSString stringWithFormat:@"%@词",v.total_words];
    [_img sd_setImageWithURL:[NSURL URLWithString:v.imgurl]];
    if ([v.payType integerValue] == 1) {
        _subStatusLabel.text = @"已订阅";
        _subStatusLabel.textColor = SUBEDCOLOR;
    }else{
        _subStatusLabel.text = @"未订阅";
        _subStatusLabel.textColor = ORANGERED;
    }
    _ordersLabel.text = v.orders;
    _fullPriceLabel.text = [NSString stringWithFormat:@"￥%@",v.full_price];
}
@end
