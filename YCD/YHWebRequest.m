//
//  YHWebRequest.m
//  YCD
//
//  Created by liyu on 2016/12/9.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "YHWebRequest.h"
@implementation YHWebRequest
+(AFHTTPSessionManager *)shareManager{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[AFHTTPSessionManager manager];
        //解析加密的HTTPS网络请求数据
        manager.securityPolicy.allowInvalidCertificates =  YES;
        //可以接受的类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript",@"text/html",@"text/plain",nil];
//        //请求队列的最大并发数
//        manager.operationQueue.maxConcurrentOperationCount = 5;
        //请求超时的时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return manager;
}
//创建post请求
+ (void)YHWebRequestForPOST:(nullable NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                 success:(nullable void(^)(id _Nonnull json))success
                                   failure:(nullable void(^)(NSURLSessionDataTask *_Nullable task,NSError *_Nonnull error))failure{
    //字符串处理
    NSString * string =[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:URLString]];
    [[YHWebRequest shareManager]POST:string parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task,id _Nullable responseObject) {
        if (success) {
            // --- > 字典类型 --- > json数据 --- >解析数据并传值
            NSError * error =nil;
            if (error !=nil) {
//                [SVProgressHUD showErrorWithStatus:@"数据解析失败,请稍后尝试!"];
                return ;
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"请求数据失败,请检查网络后重试!"];
        if (failure) {
            failure(task,error);
        }
    }];
}
@end
