//  YHSingleton.m
//  JYDS
//
//  Created by dayu on 2016/12/4.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "YHSingleton.h"
static YHSingleton *singleton;
@implementation YHSingleton
#pragma mark 重写allocWithZone:方法，alloc方法内部会调用
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super allocWithZone:zone];
    });
    return singleton;
}
#pragma mark 外部调用的单例方法，确保只init一次
+ (instancetype)shareSingleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}
#pragma mark 重写copyWithZone:方法，避免使用copy时创建多个对象
- (id)copyWithZone:(NSZone *)zone{
    return singleton;
}
@end
