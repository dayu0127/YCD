//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
//    [super dealloc];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        if (resp.errCode == 0) {
//            [YHHud showWithSuccess:@"支付成功"];
//            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//        }else if (resp.errCode == -2){
//            [YHHud showWithMessage:@"用户取消支付"];
//            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//        }else{
//            [YHHud showWithMessage:@"支付失败"];
//            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//        }
//        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"out_trade_no":[YHSingleton shareSingleton].wx_out_trade_no};
//        [YHWebRequest YHWebRequestForPOST:WXCHECK parameters:dic success:^(NSDictionary *json) {
//            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                if ([json[@"payType"] isEqualToString:@"SUCCESS"]) {
//                    [YHHud showWithSuccess:@"支付成功"];
//                    [self updateStudyBean];
//                }else{
//                    [YHHud showWithMessage:@"支付失败"];
//                }
//            }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                [YHHud showWithMessage:@"服务器出错了，请稍后重试"];
//            }else{
//                [YHHud showWithMessage:@"支付失败"];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            [YHHud showWithMessage:@"数据请求失败"];
//        }];
    }
}
#pragma mark 更新用户剩余和充值的学习豆
- (void)updateStudyBean{
//    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            [YHSingleton shareSingleton].userInfo.studyBean = [NSString stringWithFormat:@"%@",json[@"data"][@"restBean"]];
//            [YHSingleton shareSingleton].userInfo.rechargeBean = [NSString stringWithFormat:@"%@",json[@"data"][@"rechargeBean"]];
//            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateStudyBean" object:nil];
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"数据异常"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [YHHud showWithMessage:@"数据请求失败"];
//    }];
}
- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
