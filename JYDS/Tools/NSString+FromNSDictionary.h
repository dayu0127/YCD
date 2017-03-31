//
//  NSString+FromNSDictionary.h
//  JYDS
//
//  Created by liyu on 2017/3/31.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FromNSDictionary)
+ (instancetype)dictionaryToJson:(NSDictionary *)dic;
@end
