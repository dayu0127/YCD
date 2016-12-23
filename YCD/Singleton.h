//
//  Singleton.h
//  YCD
//
//  Created by dayu on 2016/12/4.
//  Copyright © 2016年 dayu. All rights reserved.
#import <Foundation/Foundation.h>
@interface Singleton : NSObject
+(instancetype)shareSingleton;
@property (strong,nonatomic) NSArray *bannerArray;
@end
