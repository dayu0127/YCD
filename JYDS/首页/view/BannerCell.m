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
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 112/375.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"zuixin"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.pageDotColor = [UIColor colorWithRed:235/255.0 green:222/255.0 blue:203/255.0 alpha:0.68];
    cycleScrollView.currentPageDotColor = [UIColor colorWithRed:1 green:78/255.0 blue:0 alpha:0.68];
//    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
//        cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
//        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
//    }else{
//        cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
//        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
//    }
    cycleScrollView.imageURLStringsGroup = self.netImages;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    [self.contentView addSubview:cycleScrollView];
}
#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    //    BannerDetailVC *bannerVC = [[BannerDetailVC alloc] init];
    //    bannerVC.navTitle = _bannerInfoArray[index][@"topTitle"];
    //    bannerVC.linkUrl = _bannerInfoArray[index][@"linkUrl"];
    //    bannerVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:bannerVC animated:YES];
    [_delegete bannerClick:index];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
