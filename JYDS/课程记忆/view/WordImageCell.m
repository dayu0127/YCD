//
//  WordImageCell.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordImageCell.h"
#import "iflyMSC/iflyMSC.h"
#import "IATConfig.h"
#import "Word.h"
#import <UIImageView+WebCache.h>
@implementation WordImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(Word *)word{
    if ([word.imgUrl isEqualToString:@"#"]) {
        [_img setImage:[UIImage imageNamed:@"course_no_word_img"]];
    }else{
        [_img sd_setImageWithURL:[NSURL URLWithString:word.imgUrl]];
    }
}
@end
