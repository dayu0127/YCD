//
//  BannerCell.h
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
@interface BannerCell : UITableViewCell<SDCycleScrollViewDelegate>
@property (strong,nonatomic) NSMutableArray *netImages;  //网络图片
@property (strong,nonatomic) NSArray *bannerInfoArray;
@end
