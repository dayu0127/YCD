//
//  MemoryMoreCell.m
//  JYDS
//
//  Created by liyu on 2017/4/11.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryMoreCell.h"
#import "Memory.h"
@implementation MemoryMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Memory *model = [Memory yy_modelWithJSON:dic];
    _titleLabel.text = model.title;
    _priceLabel.text = [NSString stringWithFormat:@"￥:%@",model.full_price];
    if ([model.payType integerValue] == 0) {
        _subStateLabel.text = @"未订阅";
        _subStateLabel.textColor = ORANGERED;
        _subImg.image = [UIImage imageNamed:@"home_nosub"];
    }else{
        _subStateLabel.text = @"已订阅";
        _subStateLabel.textColor = GREENCOLOR;
        _subImg.image = [UIImage imageNamed:@"home_subed"];
    }
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放",model.views];
}
@end
