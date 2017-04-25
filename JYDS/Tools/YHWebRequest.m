//
//  YHWebRequest.m
//  JYDS
//
//  Created by liyu on 2016/12/9.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "YHWebRequest.h"
#import <UIKit/UIKit.h>
@implementation YHWebRequest
+ (AFHTTPSessionManager *)shareManager{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[AFHTTPSessionManager manager];
        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        NSSet *cerSet = [[NSSet alloc] initWithObjects:cerData, nil];
        manager.securityPolicy  = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        [manager.securityPolicy setValidatesDomainName:NO];
        //解析加密的HTTPS网络请求数据
        manager.securityPolicy.allowInvalidCertificates =  YES;
        //可以接受的类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript",@"text/html",@"text/plain",nil];
//        //请求队列的最大并发数
//        manager.operationQueue.maxConcurrentOperationCount = 5;
        //请求超时的时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return manager;
}
//创建post请求
+ (void)YHWebRequestForPOST:(nullable NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                 success:(nullable void(^)(id _Nonnull json))success
                                   failure:(nullable void (^)(NSError *_Nonnull error))failure {
    //字符串处理
    NSString * string =[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:URLString]];
    // 参数转成JSON
    NSDictionary *paramDic = nil;
    if (parameters!=nil) {
        paramDic = @{@"paramStr":[NSString dictionaryToJson:parameters]};
    }
    [[YHWebRequest shareManager] POST:string parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id _Nullable responseObject) {
        if (success) {
            success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
