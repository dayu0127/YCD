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
#import "NSString+ConvertWanFromNum.h"
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
    [_memoryImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"][@"phoneNum"] isEqualToString:@"13312345678"]) {
        _lessonCountLabel.alpha = 0;
        _subCountLabel.alpha = 0;
    }else{
        _lessonCountLabel.text = [NSString stringWithFormat:@"%@课程",model.total_lessons];
        _subCountLabel.text = [NSString stringWithFormat:@"%@次订阅",[NSString convertWanFromNum:model.orders]];
    }
}
@end
