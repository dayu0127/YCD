//
//  YHTableDelegate.h
//  YCD
//
//  Created by liyu on 2016/12/24.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface YHTableDelegate : NSObject<UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <UITableViewDelegate>viewController;
@end
