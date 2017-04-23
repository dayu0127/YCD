//
//  HYHud.h
//  JYDS
//
//  Created by liyu on 2016/12/14.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHHud : UIView
+ (void)showWithMessage:(NSString*)text;//消息提示
+ (void)showWithStatus;//加载视图
+ (void)showRightOrWrong:(NSString *)str; //答对答错
+ (void)dismiss;
+ (void)showWithSuccess:(NSString*)successString;//成功提示
+ (void)showPaySuccessOrFailed:(NSString *)str; //支付成功失败
@end
