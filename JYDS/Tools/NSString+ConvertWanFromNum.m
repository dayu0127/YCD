//
//  NSString+ConvertWanFromNum.m
//  JYDS
//
//  Created by liyu on 2017/5/4.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "NSString+ConvertWanFromNum.h"

@implementation NSString (ConvertWanFromNum)
+ (instancetype)convertWanFromNum:(NSString *)numStr{
    NSString *resultStr;
    if ([numStr integerValue]>10000) {
        resultStr = [NSString stringWithFormat:@"%.1f万",[numStr integerValue]/10000.0];
    }else{
        resultStr = [NSString stringWithFormat:@"%@",numStr];
    }
    return resultStr;
}
@end
