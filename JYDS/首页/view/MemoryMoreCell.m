//
//  MemoryMoreCell.m
//  JYDS
//
//  Created by liyu on 2017/4/11.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryMoreCell.h"
#import "Memory.h"
#import <UIImageView+WebCache.h>
@implementation MemoryMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Memory *model = [Memory yy_modelWithJSON:dic];
    _titleLabel.text = model.title;
    if ([model.full_price integerValue] == 0) {
        _priceLabel.text = @"免费";
        _subStateLabel.text = @"";
        _subImg.alpha = 0;
        _subCountLabel.text = @"";
        NSString *playCountStr = [NSString convertWanFromNum:model.views];
        _playCountLabel.text = [NSString stringWithFormat:@"%@次播放",playCountStr];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.full_price];
        if ([model.payType integerValue] == 0) {
            _subStateLabel.text = @"未订阅";
            _subStateLabel.textColor = ORANGERED;
            _subImg.image = [UIImage imageNamed:@"home_nosub"];
        }else{
            _subStateLabel.text = @"已订阅";
            _subStateLabel.textColor = GREENCOLOR;
            _subImg.image = [UIImage imageNamed:@"home_subed"];
        }
        _subCountLabel.text = [NSString convertWanFromNum:model.orders];
        _playCountLabel.text = @"人已订阅";
    }
    [_memoryImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
}
@end
