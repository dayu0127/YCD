//
//  MessageCell.m
//  JYDS
//
//  Created by liyu on 2017/3/30.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import <UIImageView+WebCache.h>
@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _dateLabelHeight.constant = 14;
}
- (void)updateConstraints{
    [super updateConstraints];
    _dateLabelHeight.constant = 14;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(NSDictionary *)dic{
    Message *model = [Message yy_modelWithJSON:dic];
    _dateLabel1.text = [model.create_time substringWithRange:NSMakeRange(0, 10)];
    _dateLabelWidth.constant+=10;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"banner_defult"]];
    _titleLabel1.text = model.n_title;
}
- (IBAction)detailClick:(UIButton *)sender{
    [_delegate messageDetailClick:self.tag];
}
@end
