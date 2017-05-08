//
//  MemoryCell.m
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryCell.h"
#import "Memory.h"
#import <UIImageView+WebCache.h>
@implementation MemoryCell

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
    _memoryTitle.text = model.title;
    [_memoryImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
}
@end
