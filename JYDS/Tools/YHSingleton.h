//
//  YHSingleton.h
//  YHJYDS
//
//  Created by dayu on 2016/12/4.
//  Copyright © 2016年 dayu. All rights reserved.
#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface YHSingleton : NSObject
+(instancetype)shareSingleton;
@property (strong,nonatomic) UserInfo *userInfo;
@property (copy,nonatomic) NSString *ali_out_trade_no;//支付宝订单号
@property (copy,nonatomic) NSString *wx_out_trade_no;//微信订单号
@property (copy,nonatomic) NSString *payType; //#购买类型 0：K12课程单词购买 1：记忆法课程购买

@end
