//
//  MessageCenterCell.m
//  JYDS
//
//  Created by liyu on 2017/6/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MessageCenterCell.h"
#import "MessageCenter.h"
@implementation MessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(NSDictionary *)dic{
    MessageCenter *model = [MessageCenter yy_modelWithJSON:dic];
    _msgTitle.text = model.noticeTypeName;
    _msgDetail.text = [model.noticeCount integerValue] == 0 ? @"暂无消息":model.n_title;
}
@end
