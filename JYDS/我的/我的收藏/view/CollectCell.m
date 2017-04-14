//
//  CollectCell.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "CollectCell.h"
#import "WordCollect.h"
@implementation CollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addModelWithDic:(NSDictionary *)dic{
    WordCollect *model = [WordCollect yy_modelWithJSON:dic];
    _versionLabel.text = [NSString stringWithFormat:@"来自%@",model.gradeName];
    _wordLabel.text = model.word;
    _explainLabel.text = model.word_explain;
    _createTimeLabel.text = [model.create_time substringWithRange:NSMakeRange(0, 10)];
}
@end
