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
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setScrollView:(NSArray *)arr{
    _netImages = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [_netImages addObject:dic[@"url"]];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 112/375.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner_defult"]];
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
@end
