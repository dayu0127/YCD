//
//  YHMonitorKeyboard.h
//  JYDS
//
//  Created by liyu on 2017/4/12.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^YHBlock)(NSInteger height);
@interface YHMonitorKeyboard : NSObject
+(void)YHAddMonitorWithShowBack:(YHBlock)showBackBlock andDismissBlock:(YHBlock)dismissBackBlock;
@end
