//
//  BaseTableView.h
//  JYDS
//
//  Created by liyu on 2016/12/10.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BaseTableView : UITableView
@property (copy,nonatomic) void(^refreshData)();
@property (copy,nonatomic) void(^loadMoreData)();
@end
