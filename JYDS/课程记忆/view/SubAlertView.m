//
//  SubAlertView.m
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SubAlertView.h"
#import "UILabel+Utils.h"
@implementation SubAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    _subBtn.layer.borderWidth = 1.0;
    _subBtn.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
}
- (instancetype)initWithNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (IBAction)closeViewClick:(UIButton *)sender {
    [_delegate closeClick];
}
- (IBAction)continueSubBtnClick:(UIButton *)sender {
    [_delegate continueSubClick];
}
- (IBAction)invitateFriendBtnClick:(UIButton *)sender {
    [_delegate invitateFriendClick];
}
- (void)setTitle:(NSString *)title discountPrice:(NSString *)discountPrice fullPrice:(NSString *)fullPrice subType:(SubType)subType{
//    \"minDeduction\": \"50\",
//    \"minNumber\": \"1\",
//    \"maxNumber\": \"5\",
//    \"minPrice\": \"100\",
//    \"limitNumber\": \"6\"
    NSDictionary *discountDic = [NSDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"banner"]!=nil) {
        discountDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"discount"];
    }
    NSString *priceStr = [NSString stringWithFormat:@"%@-%@",discountPrice,fullPrice];
    NSString *str;
    if (subType == SubTypeMemory) {
        str = [NSString stringWithFormat:@"订阅%@的价格为%@元！",title,priceStr];
    }else{
        str = [NSString stringWithFormat:@"一次性订阅%@所有单词的价格为%@元！",title,priceStr];
    }
    NSRange priceRange= [str rangeOfString:[NSString stringWithFormat:@"%@",priceStr]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ORANGERED,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] range:NSMakeRange(priceRange.location, priceRange.length)];
    _label_0.attributedText = attStr;
    _label.text = [NSString stringWithFormat:@"邀请%@个好友，价格低至%@元。",discountDic[@"maxNumber"],discountPrice];
    _label_1.text = [NSString stringWithFormat:@"邀请%@个以上好友可获其他优惠，详见奖励邀请页面。",discountDic[@"limitNumber"]];
    [_label_1 setText:_label_1.text lineSpacing:5.0f];
    [_label_2 setText:_label_2.text lineSpacing:5.0f];
}
@end
