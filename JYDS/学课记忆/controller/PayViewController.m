//
//  PayViewController.m
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "PayViewController.h"
#import "PaymentCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *phoneNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (copy, nonatomic) NSString *token;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"back" object:nil];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    _phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    _tableHeight.constant = [WXApi isWXAppInstalled] ? 88 :44;
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:@"PaymentCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)back{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [WXApi isWXAppInstalled] ? 2 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell" forIndexPath:indexPath];
    if ([WXApi isWXAppInstalled]) {
        cell.imageView1.image = indexPath.row == 0 ? [UIImage imageNamed:@"course_alipay"] : [UIImage imageNamed:@"course_wxpay"];
        cell.title.text = indexPath.row == 0 ? @"支付宝支付" : @"微信支付";
    }else{
        cell.imageView1.image = [UIImage imageNamed:@"course_alipay"];
        cell.title.text = @"支付宝支付";
    }
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self alipayCell];
    }else{
        [self wxpayCell];
    }
}
- (void)alipayCell{
//    {
//        "userPhone":"******"    #用户手机号
//        "payType" :0            #购买类型 0：K12课程单词购买 1：记忆法课程购买
//        "classId":"***"         #课本id（选填，当payType=0时候必填）
//        "memoryId":"***"        #记忆法视频id（选填，当payType=1时候必填）
//        "token":"****"          #登陆凭证
//    }
    NSDictionary *jsonDic  = @{@"userPhone":_phoneNum,  //  #用户手机号
                                            @"payType" :@"0",         //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
                                            @"classId":_classId,       //  #课本id（选填，当payType=0时候必填）
//                               @"memoryId":"***",     //   #记忆法视频id（选填，当payType=1时候必填）
                                            @"token":_token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kAlipaySub parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *resultData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            [YHSingleton shareSingleton].ali_out_trade_no = resultData[@"out_trade_no"];
            NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithDictionary:resultData];
            [jsonDic removeObjectForKey:@"code"];
            [jsonDic removeObjectForKey:@"out_trade_no"];
            NSArray* sortedKeyArray = [[jsonDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (NSString* key in sortedKeyArray) {
                NSString *value = jsonDic[key];
                value = (__bridge_transfer  NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
                NSString* orderItem = [NSString stringWithFormat:@"%@=%@", key, value];
                [tmpArray addObject:orderItem];
            }
            NSString *orderString = [tmpArray componentsJoinedByString:@"&"];
            //调起支付宝支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"jydsapp58327007" callback:^(NSDictionary *resultDic) {
//                {
//                    "userPhone":"******"    #用户手机号
//                    "code":"***"            #支付宝支付状态码
//                    "out_trade_no":"***"    #商户订单号（选填，与transaction_id二选一）
//                    "result":"***"          #支付宝返回的订单信息
//                    "token":"****"          #登陆凭证
//                }
                NSDictionary *jsonDic = @{@"userPhone":_phoneNum,   // #用户手机号
                                                      @"code":resultDic[@"resultStatus"],        //    #支付宝支付状态码
                                                      @"out_trade_no":resultData[@"out_trade_no"], //   #商户订单号（选填，与transaction_id二选一）
                                                      @"result":resultDic[@"result"],      //    #支付宝返回的订单信息
                                                      @"token":_token};       //   #登陆凭证
                [YHWebRequest YHWebRequestForPOST:kAlipaySignCheck parameters:jsonDic success:^(NSDictionary *json) {
                    if ([json[@"code"] integerValue] == 200) {
                        //刷新订阅状态
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSubStatus" object:nil];
                        [YHHud showWithSuccess:@"支付成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }else{
                        [YHHud showWithSuccess:json[@"message"]];
                    }
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }];
        }else{
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)wxpayCell{
//    {
//        "userPhone":"******"    #用户手机号
//        "payType" :0            #购买类型 0：K12课程单词购买 1：记忆法课程购买
//        "classId":"***"         #课本id（选填，当payType=0时候必填）
//        "memoryId":"***"        #记忆法视频id（选填，当payType=1时候必填）
//        "token":"****"          #登陆凭证
//    }
    NSDictionary *jsonDic = @{@"userPhone":_phoneNum,  //  #用户手机号
                                          @"payType" :@"0",         //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
                                          @"classId":_classId,      //   #课本id（选填，当payType=0时候必填）
//                              "memoryId":"***"     //   #记忆法视频id（选填，当payType=1时候必填）
                                          @"token":_token};      //    #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWXSub parameters:jsonDic success:^(NSDictionary *json) {
        NSDictionary *resultData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
        [YHSingleton shareSingleton].wx_out_trade_no = resultData[@"out_trade_no"];
        if ([json[@"code"] integerValue] == 200) {
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = resultData[@"partnerId"];
            request.prepayId = resultData[@"prepayId"];
            request.package = resultData[@"package"];
            request.nonceStr= resultData[@"nonceStr"];
            request.timeStamp = [resultData[@"timestamp"] intValue];
            request.sign = resultData[@"sign"];
            //调起微信支付
            [WXApi sendReq:request];
        }else{
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
