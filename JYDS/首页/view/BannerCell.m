//
//  BannerCell.m
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "BannerCell.h"

@implementation BannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _netImages = [NSMutableArray array];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexImages"];
    for (NSDictionary *dic in _bannerInfoArray) {
        [_netImages addObject:dic[@"url"]];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"][@"phoneNum"] isEqualToString:@"13312345678"]) {
        _netImages = [NSMutableArray arrayWithObject:_netImages[1]];
    }
    NSLog(@"%@",_bannerInfoArray);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 112/375.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"zuixin"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.pageDotColor = [UIColor colorWithRed:235/255.0 green:222/255.0 blue:203/255.0 alpha:0.68];
    cycleScrollView.currentPageDotColor = [UIColor colorWithRed:1 green:78/255.0 blue:0 alpha:0.68];
    cycleScrollView.imageURLStringsGroup = self.netImages;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    [self.contentView addSubview:cycleScrollView];
}
#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [_delegete bannerClick:index];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
