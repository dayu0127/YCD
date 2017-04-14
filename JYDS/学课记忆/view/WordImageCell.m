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
@implementation WordImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, 100, 0, 0) withParentView:self];
    //线
    _line = [UIView new];
    [self.contentView addSubview:_line];
    CGFloat f = 204/255.0;
    _line.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1.0];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-135);
        make.height.mas_equalTo(@2);
    }];
    _line.alpha = 0;
    //显示按钮
    _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_showButton];
    _showButton.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1.0];
    _showButton.layer.masksToBounds = YES;
    _showButton.layer.cornerRadius = 3.0f;
    [_showButton setImage:[UIImage imageNamed:@"course_volume"] forState:UIControlStateNormal];
    [_showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(73);
        make.right.equalTo(self).offset(-73);
        make.bottom.equalTo(self).offset(-79);
        make.height.mas_equalTo(@42);
    }];
    _showButton.alpha = 0;
    //跟读/跟写按钮
    _rwButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rwButton];
    _rwButton.backgroundColor = [UIColor colorWithRed:131/255.0 green:46/255.0 blue:43/255.0 alpha:1.0];
    _rwButton.layer.masksToBounds = YES;
    _rwButton.layer.cornerRadius = 3.0f;
    [_rwButton setTitle:@"跟读" forState:UIControlStateNormal];
    [_rwButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rwButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_rwButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(73);
        make.right.equalTo(self).offset(-73);
        make.bottom.equalTo(self).offset(-29);
        make.height.mas_equalTo(@31);
    }];
    _rwButton.alpha = 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)showReadClick:(UIButton *)sender {
    [_delegate showRead];
}
- (IBAction)showWriteClick:(UIButton *)sender {
    [_delegate showWrite];
}
@end
