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
#import "DataSigner.h"
#import "WXApi.h"
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
    [self nightModeConfiguration];
    _studyDouLabel.text = [NSString stringWithFormat:@"%zd学习豆，",_money*PAY_PROPORTION];
    _moneyLabel.text = [NSString stringWithFormat:@"%zd元",_money];
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:@"PaymentCell"];
}
- (void)nightModeConfiguration{
    _payLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _studyDouLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _moneyLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
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
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [YHHud showWithStatus:@"准备支付"];
    if (indexPath.row == 0) {
    //支付宝支付
        [YHWebRequest YHWebRequestForPOST:@"http://www.zhongshuo.cn:8088/payAPI/API/order_generateAPI" parameters:nil success:^(NSDictionary *json) {
            [YHHud dismiss];
            NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithDictionary:json];
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
                NSLog(@"reslut ======== %@",resultDic);
                [YHHud showWithMessage:resultDic[@"memo"]];
            }];
        }];
    }else{
    //微信支付
        if (![WXApi isWXAppInstalled]) {
            [YHHud dismiss];
            [YHHud showWithMessage:@" 请您先安装微信"];
        }else{
            [YHWebRequest YHWebRequestForPOST:@"http://www.zhongshuo.cn:8088/payAPI/API/wx_unifiedorderAPI" parameters:nil success:^(NSDictionary *json) {
                [YHHud dismiss];
                if (![json[@"prepayId"] isEqualToString:@""]) {
                    PayReq *request = [[PayReq alloc] init];
                    request.partnerId = json[@"partnerId"];
                    request.prepayId = json[@"prepayId"];
                    request.package = json[@"package"];
                    request.nonceStr= json[@"nonceStr"];
                    request.timeStamp = [json[@"timestamp"] intValue];
                    request.sign = json[@"sign"];
                     //调起微信支付
                    [WXApi sendReq:request];
                }
            }];
        }
    }
}
@end
