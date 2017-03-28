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
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 112/375.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"zuixin"]];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
    }else{
        cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
    }
//    cycleScrollView.imageURLStringsGroup = self.netImages;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    [self.contentView addSubview:cycleScrollView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
