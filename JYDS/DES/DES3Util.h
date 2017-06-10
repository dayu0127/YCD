//
//  DES3Util.h
//  TRY
//
//  Created by CY on 16/7/26.
//  Copyright © 2016年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;
// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end
