//
//  NSDictionary+FromNSString.h
//  JYDS
//
//  Created by liyu on 2017/3/31.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FromNSString)
+ (instancetype)dictionaryWithJsonString:(NSString *)jsonString;
@end
