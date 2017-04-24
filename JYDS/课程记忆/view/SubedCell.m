//
//  SubedCell.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SubedCell.h"
#import "Word.h"
@implementation SubedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _wordLabel = [UILabel new];
        _wordLabel.font = [UIFont systemFontOfSize:15.0f];
        _wordLabel.textColor = GRAYCOLOR;
        [self addSubview:_wordLabel];
        [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_collectButton setImage:[UIImage imageNamed:@"course_collect"] forState:UIControlStateNormal];
//        [self addSubview:_collectButton];
//        [_collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-15);
//            make.centerY.equalTo(self);
//        }];
        UIView *line = [UIView new];
        line.backgroundColor = SEPCOLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}
- (void)addModelWithDic:(NSDictionary *)dic{
    Word *model = [Word yy_modelWithJSON:dic];
    _wordLabel.text = model.word;
//    if ([model.collectionType integerValue] == 0) {
//        [_collectButton setImage:[UIImage imageNamed:@"course_collect"] forState:UIControlStateNormal];
//    }else{
//        [_collectButton setImage:[UIImage imageNamed:@"course_collected"] forState:UIControlStateNormal];
//    }
}
@end
