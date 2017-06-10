//
//  CommentCell.m
//  JYDS
//
//  Created by liyu on 2017/4/12.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "CommentCell.h"
#import "MemoryComment.h"
#import <UIImageView+WebCache.h>
@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _userHeadImageView.layer.masksToBounds = YES;
    _userHeadImageView.layer.cornerRadius = 18.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addModelWithDic:(NSDictionary *)dic{
    MemoryComment *model = [MemoryComment yy_modelWithJSON:dic];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_img]];
    [_userHeadImageView sd_setImageWithURL:headUrl];
    _likeCountLabel.text = model.likes;
    _nickNameLabel.text = model.nick_name;
    _commemtLabel.text = model.content;
    _commentTimeLabel.text = model.create_time;
}
@end
