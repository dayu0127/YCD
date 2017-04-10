//
//  HYHud.h
//  JYDS
//
//  Created by liyu on 2016/12/14.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHHud : UIView
+(void)showWithMessage:(NSString*)text;//消息提示
+(void)showWithStatus;//加载视图
+(void)dismiss;
+(void)showWithSuccess:(NSString*)successString;//成功提示
@end
