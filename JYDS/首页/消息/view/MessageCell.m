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
    
}
- (void)updateConstraints{
    [super updateConstraints];
    _dateLabelHeight.constant = 14;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailClick:(id)sender {
    [_delegate messageDetail];
}
- (void)setModel:(NSDictionary *)dic{
    Message *model = [Message yy_modelWithJSON:dic];
    _dateLabel1.text = [model.create_time substringWithRange:NSMakeRange(0, 10)];
    _dateLabelWidth.constant+=20;
//    [_img sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"m1"]];
    NSURL *url = [NSURL URLWithString:model.imgUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [_img setImage:image];
    _titleLabel1.text = model.n_title;
}
@end
