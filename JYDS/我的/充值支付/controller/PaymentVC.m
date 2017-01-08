//
//  PaymentVC.m
//  JYDS
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PaymentVC.h"
#import "PaymentCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface PaymentVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *studyDouLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PaymentVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _payLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _studyDouLabel.text = [NSString stringWithFormat:@"%zd学习豆，",_money*PAY_PROPORTION];
    _studyDouLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _moneyLabel.text = [NSString stringWithFormat:@"%zd元",_money];
    _moneyLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:@"PaymentCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell" forIndexPath:indexPath];
    cell.imageView1.image = indexPath.row == 0 ? [UIImage imageNamed:@"alipaylogo_64x64"] : [UIImage imageNamed:@"wxlogo_64x64"];
    cell.title.text = indexPath.row == 0 ? @"支付宝支付" : @"微信支付";
    return cell;
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    //支付宝支付
        NSString *appID = @"2016121704355858";
        NSString *privateKey = @"MIICXwIBAAKBgQCtuXeBYtUnkeTfwGr8G2f20lNCAcFKlMg91+EniKbgIYu6imIvb/RnmhWPlW0SmyYaIaZl3rb2hDKKComvVmRhs5LGxTdMsUkp6w0uGx2mh2HHLmIECcf/9XmHQo1hFLkKYqn2dsxeDxYjxtmq8XL4rhtKDGWYeLzXoUxAYU4JewIDAQABAoGBAJexnWKDdHDq+hlPIZwmKi/iFAVNFwUSyY8G1Hn63wxS/nnSoE2fyqA0caNA7U8T3r9upqfJQ6YaZS8YaIWMQHWHTa/4FQWkoAyLN+oByg4Wv4sBaWxY3zuzv4wqiPpXfL8VpFyn4uYNYoBRfXunfHUOWopq80jANfmGDa44WgsxAkEA1d/0Zm3ctkzjJenmz/Vl+vPUbFFh6xLw6mEgNqkcjzXJXNrb4K29q+Cq4UUNkD7wjmVASDrCufA3fujaRY3qXwJBAM/xCtXwNwHylOX9NB8caCmFsdWhTpuFAIAG253GqsiQwunKHnor12tNrNfP39xCcWGpPZJTNH8BDA193yt8rmUCQQC3+AVtmjDRKv/0m+crmMXZAKYHalWU9F0A7vzbp8nmMfj8g1HBSRGu5/l0/oX1Pv6DLfsGZm0brdK+uqMOU013AkEAhauszIRDyCO5pfLT25/2MaL5A5xTHNQt0x8VdGIujQnJ0mIUn3KpYxgmoQDHJh8sJZyWsQZ9u5rftZiRqrHWpQJBAJeo2xgRF2IwrF626mNnmtA32jGDE4aFpvVLR0gYiR/1Meu+8651Qqvdn4ppHgciwCjJ4urLAn4mDaZIEvp/EMo=";
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        
        // NOTE: app_id设置
        order.app_id = appID;
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        
        // NOTE: sign_type设置
        order.sign_type = @"RSA";
        
        // NOTE: 商品数据
        order.biz_content = [BizContent new];
        order.biz_content.body = @"我是测试数据";
        order.biz_content.subject = @"1";
        order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = @"30m"; //超时时间设置
        order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        NSLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderInfo];
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"alisdkdemo";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    }else{
    //微信支付

    }
}
@end
