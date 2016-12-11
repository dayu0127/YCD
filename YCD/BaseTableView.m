//
//  BaseTableView.m
//  YCD
//
//  Created by liyu on 2016/12/10.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "BaseTableView.h"
#import <MJRefresh.h>
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
//#define MJRandomData [NSString stringWithFormat:@"随机数据---%d",arc4random_uniform(1000000)]
static const CGFloat MJDuration = 2.0;
@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {

//        //下拉刷新数据 隐藏状态和时间
//        
//        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//        MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData1)];
       MJChiBaoZiHeader *header =  [MJChiBaoZiHeader headerWithRefreshingBlock:^{
           if (_refreshData) {
               self.refreshData();
           }
           // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               // 刷新表格
               [self reloadData];
               
               // 拿到当前的下拉刷新控件，结束刷新状态
               [self.mj_header endRefreshing];
           });
        }];
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 隐藏状态
        header.stateLabel.hidden = YES;
        
        // 马上进入刷新状态
        [header beginRefreshing];
        
        // 设置header
        self.mj_header = header;
//
//        
//        
//        //上拉加载更多 隐藏刷新状态的文字
//        
//        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            if (_refreshData) {
//                self.refreshData();
//            }
//            // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                // 刷新表格
//                [self reloadData];
//                
//                // 拿到当前的下拉刷新控件，结束刷新状态
//                [self.mj_header endRefreshing];
//            });
//        }];
//
//        // 马上进入刷新状态
//        [self.mj_header beginRefreshing];

        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
            if (_loadMoreData) {
                self.loadMoreData();
            }
            // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self reloadData];
                
                // 拿到当前的上拉刷新控件，结束刷新状态
                [self.mj_footer endRefreshing];
            });
        }];
        
        // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
        //    footer.triggerAutomaticallyRefreshPercent = 0.5;
        
        // 隐藏刷新状态的文字
        footer.refreshingTitleHidden = YES;
        
        // 设置footer
        self.mj_footer = footer;
    }
    return self;
}
@end
