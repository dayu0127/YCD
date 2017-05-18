//
//  YHSingleton.h
//  YHJYDS
//
//  Created by dayu on 2016/12/4.
//  Copyright © 2016年 dayu. All rights reserved.
#import <Foundation/Foundation.h>
#import "UserInfo.h"
typedef NS_ENUM(NSInteger, SubType) {
    SubTypeMemory,   //记忆法
    SubTypeWord,     //单词
    SubTypeMemorySingle //单个记忆法
};
@interface YHSingleton : NSObject
+(instancetype)shareSingleton;
@property (strong,nonatomic) UserInfo *userInfo;
@property (copy,nonatomic) NSString *ali_out_trade_no;//支付宝订单号
@property (copy,nonatomic) NSString *wx_out_trade_no;//微信订单号
@property (assign,nonatomic) SubType subType;

@end
