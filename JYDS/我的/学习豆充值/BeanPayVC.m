//
//  BeanPayVC.m
//  JYDS
//
//  Created by liyu on 2017/7/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "BeanPayVC.h"
#import "BeanPayView.h"
#import <StoreKit/StoreKit.h>
#import "BaseNavViewController.h"
@interface BeanPayVC ()<BeanPayViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (copy,nonatomic) NSString *productId;
@property (copy,nonatomic) NSString *productPrice;
@end

@implementation BeanPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat w = (WIDTH-64)/3.0;
    CGFloat h = w*0.7;
    CGFloat x,y;
    for (NSInteger row = 0; row<2; row++) {
        y = 116+row*(16+h);
        for (NSInteger col = 0; col<3; col++) {
            x = 16+col*(16+w);
            BeanPayView *beanPayView = [[BeanPayView alloc] initWithFrame:CGRectMake(x, y, w, h) tag:row*3+col];
            beanPayView.moneyLabel.text = [NSString stringWithFormat:@"￥%@",PAY_ARRAY[row*3+col]];
            beanPayView.studyBeanLabel.text = [NSString stringWithFormat:@"%@学习豆",PAY_ARRAY[row*3+col]];
            beanPayView.delegate = self;
            [self.view addSubview:beanPayView];
        }
    }
    self.topSpace.constant = 88+h*2;
    //监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)itemClick:(NSInteger)itemIndex{
    [YHHud showWithStatus];
    float f = [PAY_ARRAY[itemIndex] floatValue];
    _productPrice = [NSString stringWithFormat:@"%.1f",f];
    [self validateIsCanBought:[NSString stringWithFormat:@"%@%@",kProductID,PAY_ARRAY[itemIndex]]];
}
//--------------------------------------------内购开始-------------------------------------------------------

//用户点击一个IAP项目时，首先查询用户是否允许应用内付费(tableViewCell点击时，传递内购商品ProductId，ProductID可以提前存储到本地，用到时直接获取即可)
-(void)validateIsCanBought:(NSString *)productId{
    if ([SKPaymentQueue canMakePayments]) {
        _productId = productId;
        [self getProductInfo:@[productId]];
    }else{
        NSLog(@"失败,用户禁止应用内付费购买");
    }
}

//通过该IAP的Product ID向App Store查询，获取SKPayment实例，接着通过SKPaymentQueue的addPayment方法发起一个购买的操作
//下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目，否则会查询失败
-(void)getProductInfo:(NSArray *)productIds{
    NSSet *set = [NSSet setWithArray:productIds];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];

}

#pragma mark - SKProductsRequestDelegate
//查询的回调函数
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [YHHud dismiss];
    //获取到的所有内购商品
    NSArray *myProduct = response.products;
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题(localizedTitle):%@" , product.localizedTitle);
        NSLog(@"产品描述信息(localizedDescription):%@" , product.localizedDescription);
        NSLog(@"价格(price):%@" , product.price);
        NSLog(@"商品ID(productIdentifier):%@" , product.productIdentifier);
    }
    //判断个数
    if (myProduct.count==0) {
        [YHHud showWithMessage:@"无法获取产品信息，购买失败。"];
        return;
    }
    //发起一个购买操作
    SKPayment *payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//请求完成
- (void)requestDidFinish:(SKRequest *)request{

}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [YHHud showWithMessage:@"购买失败"];
}
#pragma mark - SKPaymentTransactionObserver
//当用户购买的操作有结果时，就会触发下面的回调函数，相应进行处理
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:  //交易完成
                NSLog(@"transactionIdentifier = %@",transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:     //交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:  //已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
//                [YHHud showWithMessage:@"交易中"];
                [YHHud showWithStatus];
                break;
            default:
                break;
        }
    }
}

//交易完成后的操作
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    if (_productId!=nil) {
        [self buy:transaction];
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
//交易失败后的操作
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [YHHud showWithMessage:@"购买失败"];
    }else{
        [YHHud showWithMessage:@"用户取消购买"];
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
//已经购买过该商品
-(void)restoreTransaction:(SKPaymentTransaction *)transaction{
    //对于已购买商品，处理恢复购买的逻辑
    if (_productId!=nil) {
        [self buy:transaction];
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)buy:(SKPaymentTransaction *)transaction{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *dic = @{
        @"userPhone":self.phoneNum,      //  #用户手机号
        @"token":self.token,            //      #用户登陆凭证
        @"receipt_data":encodeStr,        //   #苹果凭证
        @"stuBean":_productPrice,                //    #商品价格
        @"product_id":_productId,     //    #产品类型
    };
    [YHWebRequest YHWebRequestForPOST:kApplePayCheck parameters:dic success:^(NSDictionary *json) {
        //移除transaction购买操作
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        if ([json[@"code"] integerValue] == 200) {
            [YHHud showWithSuccess:@"充值成功！"];
            NSDictionary *jsonDic1  = @{
                @"userPhone":self.phoneNum,    //    #用户手机号
                @"token":self.token  // #登陆后的token值
            };
            [YHWebRequest YHWebRequestForPOST:kGetUser parameters:jsonDic1 success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    NSDictionary *jsonDic1 = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    NSString *bean = [NSString stringWithFormat:@"%@",jsonDic1[@"user"][@"stuBean"]];
                    [YHSingleton shareSingleton].userInfo.stuBean = bean;
                    [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                    [_delegate updateBean:bean];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    [YHHud showWithMessage:json[@"message"]];
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [YHHud showWithMessage:@"网络异常,获取学习豆失败"];
            }];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithSuccess:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //移除transaction购买操作
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [YHHud showWithMessage:@"请求失败"];
    }];
}
- (void)dealloc{
    //移除购买监听
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
//--------------------------------------------内购结束-------------------------------------------------------
- (IBAction)toOfficialWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.jydsapp.com"]];
}

@end
