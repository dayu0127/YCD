//
//  NSString+FromNSDictionary.m
//  JYDS
//
//  Created by liyu on 2017/3/31.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "NSString+FromNSDictionary.h"

@implementation NSString (FromNSDictionary)
+ (instancetype)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
