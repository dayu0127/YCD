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
@end
