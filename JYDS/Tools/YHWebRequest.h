//
//  YHWebRequest.h
//  JYDS
//
//  Created by liyu on 2016/12/9.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface YHWebRequest : NSObject
+ (void)YHWebRequestForPOST:(nullable NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                 success:(nullable void(^)(id _Nonnull json))success
                                   failure:(nullable void (^)(NSError *_Nonnull error))failure;
@end
