//
//  RechargeVC.m
//  StoreKit
//
//  Created by 夏远全 on 2017/2/21.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "RechargeVC.h"
#import <StoreKit/StoreKit.h>


@interface RechargeVC ()
@property (strong,nonatomic) UIAlertController *alertViewVC;
@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}




//用户点击一个IAP项目时，首先查询用户是否允许应用内付费(tableViewCell点击时，传递内购商品ProductId，ProductID可以提前存储到本地，用到时直接获取即可)
-(void)validateIsCanBought{
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:@[@"ProductIds"]];
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
    
    //获取到的所有内购商品
    NSArray *myProducts = response.products;
    
    //判断个数
    if (myProducts.count==0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    
    //发起一个购买操作
    SKPayment *payment = [SKPayment paymentWithProduct:myProducts[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
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
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

//交易完成后的操作
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSData *transactionReceiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receipt = [transactionReceiptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    if ([productIdentifier length]>0) {
        //向自己的服务器验证购买凭证
        NSLog(@"%@",receipt);
    }
    
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//交易失败后的操作
-(void)failedTransaction:(SKPaymentTransaction *)transaction{
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    }else{
        NSLog(@"用户取消交易");
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//已经购买过该商品
-(void)restoreTransaction:(SKPaymentTransaction *)transaction{
    
    //对于已购买商品，处理恢复购买的逻辑
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
@end
