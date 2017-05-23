//
//  ModuleListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ModuleListVC.h"
#import "ModuleCell.h"
#import "WordListVC.h"
#import "WordSubedList.h"
#import "SubAlertView.h"
#import "PayViewController.h"
#import "UILabel+Utils.h"
#import "WordSearchListVC.h"
#import <StoreKit/StoreKit.h>
@interface ModuleListVC ()<UITableViewDelegate,UITableViewDataSource,SubAlertViewDelegate,UISearchBarDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *moduleList;
@property (copy,nonatomic) NSString *unitId;
@property (strong,nonatomic) JCAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *subAllButton;
@property (copy,nonatomic) NSString *inviteCount;
@property (copy,nonatomic) NSString *payPrice;
@property (assign,nonatomic) NSInteger wordNum;
@property (strong,nonatomic) NSArray *wordSearchResultArray;
@property (copy,nonatomic) NSString *searchContent;
@property (copy,nonatomic) NSString *productId;
@end

@implementation ModuleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWordSubStatus) name:@"updateWordSubStatus" object:nil];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    [_tableView registerNib:[UINib nibWithNibName:@"ModuleCell" bundle:nil] forCellReuseIdentifier:@"ModuleCell"];
    [YHHud showWithStatus];
//    {
//        "classId":"******"      #课本ID
//        "userPhone":"***"       #用户手机号
//        "token":"****"          #登陆凭证
//    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary *jsonDic = @{@"classId":_classId,    // #课本ID
                                          @"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,     //  #用户手机号
                                          @"token":token};         // #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kModuleList parameters:jsonDic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _moduleList = resultDic[@"unitList"];
            [_tableView reloadData];
            if ([_payType isEqualToString:@"0"]) {
                _subAllButton.alpha = 1;
            }else{
                _subAllButton.alpha = 0;
            }
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        NSLog(@"%@",error);
    }];
    //监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
#pragma mark 单词搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (REGEX(LETTER_RE, searchBar.text) == NO) {
        [YHHud showWithMessage:@"请输入英文单词"];
    }else{
        if (![searchBar.text isEqualToString:@""]) {
            NSDictionary *jsonDic = @{
                @"userPhone":self.phoneNum,   //     #用户手机号
                @"token":self.token,            //      #用户登陆凭证
                @"selContent":searchBar.text       //      #查询内容
            };
            [YHWebRequest YHWebRequestForPOST:kSelectWord parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    _wordSearchResultArray = resultDic[@"selWordList"];
                    _searchContent = searchBar.text;
                    [self performSegueWithIdentifier:@"toWordSearchVC" sender:self];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    [YHHud showWithMessage:json[@"message"]];
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
}
- (void)updateWordSubStatus{
    _subAllButton.alpha = 0;
    _payType = @"1";
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _moduleList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCell" forIndexPath:indexPath];
    [cell addModelWithDic:_moduleList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _unitId = _moduleList[indexPath.row][@"unitId"];
    if ([_payType isEqualToString:@"0"]) {
        [self performSegueWithIdentifier:@"toWordList" sender:self];
    }else{
        _wordNum = [_moduleList[indexPath.row][@"wrodNum"] integerValue];
        [self performSegueWithIdentifier:@"toWordSubedList" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordSearchVC"]) {
        WordSearchListVC *wordSearchListVC = segue.destinationViewController;
        wordSearchListVC.wordSearchResultArray = _wordSearchResultArray;
        wordSearchListVC.searchContent = _searchContent;
    }else if ([segue.identifier isEqualToString:@"toWordList"]) {
        WordListVC *wordListVC = segue.destinationViewController;
        wordListVC.classId = _classId;
        wordListVC.unitId = _unitId;
        wordListVC.payType = _payType;
        wordListVC.gradeName = _gradeName;
    }else if([segue.identifier isEqualToString:@"toWordSubedList"]){
        WordSubedList *wordSubedList = segue.destinationViewController;
        wordSubedList.classId = _classId;
        wordSubedList.unitId = _unitId;
        wordSubedList.wordNum = _wordNum;
    }else if ([segue.identifier isEqualToString:@"toPayViewController"]){
//        PayViewController *payVC = segue.destinationViewController;
//        payVC.classId = _classId;
//        payVC.inviteCount = _inviteCount;
//        payVC.preferentialPrice = _preferentialPrice;
//        payVC.payPrice = _payPrice;
//        payVC.subType = SubTypeWord;
//        [YHSingleton shareSingleton].subType = SubTypeWord;
    }
}
- (IBAction)subAllWordBtnClick:(UIButton *)sender {
    SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
    [subAlertView setTitle:_gradeName discountPrice:_preferentialPrice fullPrice:_full_price subType:SubTypeWord];
    subAlertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:subAlertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
#pragma mark 继续订阅
- (void)continueSubClick{
    [_alertView dismissWithCompletion:^{
//        {
//            "userPhone":"******"    #用户手机号
//            "token":"****"          #登陆凭证
//            "objectId":"****"       #目标id
//            "payType":"***"         #支付类型 1：记忆法  0：单词课本
//        }
        [YHHud showWithStatus];
        NSDictionary *jsonDic = @{
            @"userPhone":self.phoneNum,  //  #用户手机号
            @"payType" :@"0",         //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
            @"objectId":_classId,       //  #目标id
            @"token":self.token       //   #登陆凭证
        };
        [YHWebRequest YHWebRequestForPOST:kOrderPrice parameters:jsonDic success:^(NSDictionary *json) {
            [YHHud dismiss];
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _inviteCount = [NSString stringWithFormat:@"%@",dataDic[@"inviteNum"]];
//                float oldPrice = [dataDic[@"price"] floatValue];
//                _preferentialPrice = [NSString stringWithFormat:@"￥%0.2f",oldPrice-newPrice];
//                _payPrice = [NSString stringWithFormat:@"￥%0.2f",newPrice];
//                [self performSegueWithIdentifier:@"memoryListToPayVC" sender:self];
//                NSInteger preferentialPrice = (NSInteger)(oldPrice-newPrice);
                NSInteger payPrice = [dataDic[@"discountPrice"] integerValue];
                switch (payPrice) {
                    case 100:
                        [self validateIsCanBought:ProductID_textbook100];
                        break;
                    case 150:
                        [self validateIsCanBought:ProductID_textbook150];
                        break;
                    case 200:
                        [self validateIsCanBought:ProductID_textbook200];
                        break;
                    case 250:
                        [self validateIsCanBought:ProductID_textbook250];
                        break;
                    case 300:
                        [self validateIsCanBought:ProductID_textbook300];
                        break;
                    case 350:
                        [self validateIsCanBought:ProductID_textbook350];
                        break;
                    default:
                        break;
                }
            }else{
                [YHHud dismiss];
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud dismiss];
            NSLog(@"%@",error);
        }];
    }];
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
//    [YHHud showWithMessage:@"请求支付成功"];
//    [YHHud dismiss];
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
                [YHHud showWithStatus];
                break;
            default:
                break;
        }
    }
}

//交易完成后的操作(验证支付)
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    if (_productId!=nil) {
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
            @"type":@"0",                //    #购买类型（0：课本购买        1：记忆法购买）
            @"product_id":_productId,     //    #产品类型
            @"object_id":_classId      //     #产品ID
        };
        [YHWebRequest YHWebRequestForPOST:kApplePayCheck parameters:dic success:^(NSDictionary *json) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            if ([json[@"code"] integerValue] == 200) {
                [self updateWordSubStatus];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWordSubStatus" object:nil];
                [YHHud showWithSuccess:@"订阅成功"];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithSuccess:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            NSLog(@"%@",error);
            [YHHud showWithMessage:@"请求失败"];
        }];
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
//交易失败后的操作
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [YHHud showWithMessage:@"订阅失败"];
    }else{
        [YHHud showWithMessage:@"用户取消订阅"];
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
//已经购买过该商品
-(void)restoreTransaction:(SKPaymentTransaction *)transaction{
    if (_productId!=nil) {
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
            @"type":@"0",                //    #购买类型（0：课本购买        1：记忆法购买）
            @"product_id":_productId,     //    #产品类型
            @"object_id":_classId      //     #产品ID
        };
        [YHWebRequest YHWebRequestForPOST:kApplePayCheck parameters:dic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                [self updateWordSubStatus];
                [YHHud showWithSuccess:@"订阅成功"];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithSuccess:json[@"message"]];
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [YHHud showWithMessage:@"请求失败"];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }];
    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
//--------------------------------------------内购结束-------------------------------------------------------
#pragma mark 邀请好友
- (void)invitateFriendClick{
    [_alertView dismissWithCompletion:^{
        [self performSegueWithIdentifier:@"moduleListToInviteRewards" sender:self];
    }];
}
#pragma mark 关闭提示框
- (void)closeClick{
    [_alertView dismissWithCompletion:nil];
}
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //移除购买监听
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//}
@end
