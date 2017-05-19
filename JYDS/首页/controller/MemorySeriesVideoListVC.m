//
//  MemorySeriesVideoListVC.m
//  JYDS
//
//  Created by liyu on 2017/5/2.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemorySeriesVideoListVC.h"
#import "MemorySeriseCell.h"
#import "MemoryDetailVC.h"
#import "Memory.h"
#import <UIImageView+WebCache.h>
#import "SubAlertView.h"
#import "PayViewController.h"
#import <StoreKit/StoreKit.h>
@interface MemorySeriesVideoListVC ()<UITableViewDelegate,UITableViewDataSource,MemoryDetailVCDelegate,SubAlertViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lessonNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) Memory *memory;
@property (strong,nonatomic) NSMutableArray *memorySeriesList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomSpace;
@property (strong,nonatomic) UIView *bottomBgView;
@property (assign,nonatomic) NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIButton *subAllButton;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *inviteCount;
@property (copy,nonatomic) NSString *preferentialPrice;
@property (copy,nonatomic) NSString *payPrice;
@property (copy,nonatomic) NSString *objectId;
@property (assign,nonatomic) SubType subType;
@end

@implementation MemorySeriesVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMemoryList) name:@"updateMemorySubStatus" object:nil];
    _lessonNameLabel.text = _lessonName;
    [self loadMemoryList];
    [_tableView registerNib:[UINib nibWithNibName:@"MemorySeriseCell" bundle:nil] forCellReuseIdentifier:@"MemorySeriseCell"];
    //监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
- (void)addSubAllBtn{
    _bottomBgView = [UIView new];
    _bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBgView];
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@65);
    }];
    UIButton *subAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [subAllButton setTitle:@"邀请好友 领取优惠" forState:UIControlStateNormal];
    [subAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subAllButton.backgroundColor = ORANGERED;
    subAllButton.layer.masksToBounds = YES;
    subAllButton.layer.cornerRadius = 3.0f;
    subAllButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [subAllButton addTarget:self action:@selector(subAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBgView addSubview:subAllButton];
    [subAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bottomBgView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadMemoryList{
    _pageIndex = 1;
    [self loadDataWithRefreshStatus:UITableViewRefreshStatusAnimation pageIndex:_pageIndex];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self loadDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self loadDataWithRefreshStatus:UITableViewRefreshStatusFooter pageIndex:_pageIndex];
    }];
}
- (void)loadDataWithRefreshStatus:(UITableViewRefreshStatus)status pageIndex:(NSInteger)pageIndex{
    if (status==UITableViewRefreshStatusAnimation) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{
          @"userPhone": self.phoneNum,  // #用户手机号
          @"token": self.token,          //      #用户登陆凭证
          @"lessonId": _lessonId, // #记忆法系列ID
          @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex]         //    #页数
    };
    [YHWebRequest YHWebRequestForPOST:kMemoryList parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"getMemoryList"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                _memorySeriesList = [NSMutableArray arrayWithArray:resultArray];
                if ([self.phoneNum isEqualToString:@"13312345678"]) {
                    _memorySeriesList = [NSMutableArray arrayWithObject:resultArray[0]];
                }
                [_tableView reloadData];
                NSInteger count = 0;
                for (NSInteger i = 0; i<_memorySeriesList.count; i++) {
                    NSString *lastMemoryPayType = [NSString stringWithFormat:@"%@",_memorySeriesList[i][@"payType"]];
                    if ([lastMemoryPayType isEqualToString:@"1"]) {
                        count++;
                    }
                }
                if (count == _memorySeriesList.count) {
                    _tableBottomSpace.constant = 0;
                }else{
                    _tableBottomSpace.constant = 65;
                    _bottomBgView = [UIView new];
                    _bottomBgView.backgroundColor = [UIColor whiteColor];
                    [self.view addSubview:_bottomBgView];
                    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.equalTo(self.view);
                        make.height.mas_equalTo(@65);
                    }];
                    UIButton *subAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    [subAllButton setTitle:[NSString stringWithFormat:@"订阅%@",_lessonName] forState:UIControlStateNormal];
                    [subAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    subAllButton.backgroundColor = ORANGERED;
                    subAllButton.layer.masksToBounds = YES;
                    subAllButton.layer.cornerRadius = 3.0f;
                    subAllButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                    [subAllButton addTarget:self action:@selector(subAllClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_bottomBgView addSubview:subAllButton];
                    [subAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(_bottomBgView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
                    }];
                }
                //本地保存视频是否被点赞
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"] == nil) {
                    NSMutableDictionary *likesDic = [[NSMutableDictionary alloc] init];
                    for (NSDictionary *dic in _memorySeriesList) {
                        [likesDic setObject:@"0" forKey:dic[@"memoryId"]];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:likesDic] forKey:@"likesDic"];
                }
                if (status==UITableViewRefreshStatusHeader) {
                    [self.tableView.mj_header endRefreshing];
                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }else if (status == UITableViewRefreshStatusFooter){
                [_memorySeriesList addObjectsFromArray:resultArray];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }else if([json[@"code"] integerValue] == 106){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
            if (status==UITableViewRefreshStatusHeader) {
                [self.tableView.mj_header endRefreshing];
            }else if (status==UITableViewRefreshStatusFooter){
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (status==UITableViewRefreshStatusHeader) {
            [self.tableView.mj_header endRefreshing];
        }else if (status==UITableViewRefreshStatusFooter){
            [self.tableView.mj_footer endRefreshing];
        }else if (status==UITableViewRefreshStatusAnimation){
            [YHHud dismiss];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _memorySeriesList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH*182/375.0+39;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemorySeriseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemorySeriseCell" forIndexPath:indexPath];
    cell.titleLabel.text = _memorySeriesList[indexPath.row][@"title"];
    NSString *payType = [NSString stringWithFormat:@"%@",_memorySeriesList[indexPath.row][@"payType"]];
    if ([payType isEqualToString:@"0"]) {
        cell.subImg.image = [UIImage imageNamed:@"home_nosub"];
    }else{
        cell.subImg.image = [UIImage imageNamed:@"home_subed"];
    }
    [cell.seriseImageView sd_setImageWithURL:[NSURL URLWithString:_memorySeriesList[indexPath.row][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"home_memoryImg"]];
    NSString *likesStr = [NSString convertWanFromNum:_memorySeriesList[indexPath.row][@"likes"]];
    cell.likesLabel.text = [NSString stringWithFormat:@"%@人点赞",likesStr];
    NSString *playCountStr = [NSString convertWanFromNum:_memorySeriesList[indexPath.row][@"views"]];
    cell.playCountLabel.text = [NSString stringWithFormat:@"%@次播放",playCountStr];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _memory = [Memory yy_modelWithJSON:_memorySeriesList[indexPath.row]];
    if ([_memory.payType isEqualToString:@"0"]) {
        _objectId = _memory.memoryId;
        _subType = SubTypeMemorySingle;
        SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
        [subAlertView setTitle:_memory.title discountPrice:_memory.preferentialPrice fullPrice:_memory.full_price subType:SubTypeMemory];
        subAlertView.delegate = self;
        _alertView = [[JCAlertView alloc] initWithCustomView:subAlertView dismissWhenTouchedBackground:NO];
        [_alertView show];
    }else{
        [self performSegueWithIdentifier:@"MemorySeriesToDetail" sender:self];
    }
}
- (void)subAllClick:(UIButton *)sender {
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,  //  #用户手机号
        @"memoryId":_lessonId,       //  #目标id
        @"token":self.token       //   #登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kGetOrderSumPrice parameters:jsonDic success:^(NSDictionary *json) {
         [YHHud dismiss];
        if ([json[@"code"] integerValue] == 200) {
            _objectId = _lessonId;
            _subType = SubTypeMemory;
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
            [subAlertView setTitle:_lessonName discountPrice:dataDic[@"discountPrice"] fullPrice:dataDic[@"full_price"] subType:SubTypeMemory];
//            NSLog(@"%@",subAlertView.label_0.text);
//            subAlertView.label_0_height.constant = [subAlertView.label_0.text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0f] forKey:NSFontAttributeName] context:nil].size.height+9;
            subAlertView.delegate = self;
            _alertView = [[JCAlertView alloc] initWithCustomView:subAlertView dismissWhenTouchedBackground:NO];
            [_alertView show];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
         [YHHud dismiss];
        NSLog(@"%@",error);
    }];
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
        NSString *payType;
        if (_subType == SubTypeMemory) {
            payType = @"1";
        }else{
            payType = @"2";
        }
        NSDictionary *jsonDic = @{
            @"userPhone":self.phoneNum,  //  #用户手机号
            @"payType" :payType,         //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
            @"objectId":_objectId,       //  #目标id
            @"token":self.token       //   #登陆凭证
        };
        [YHWebRequest YHWebRequestForPOST:kOrderPrice parameters:jsonDic success:^(NSDictionary *json) {
            
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _inviteCount = [NSString stringWithFormat:@"%@",dataDic[@"inviteNum"]];
//                float oldPrice = [dataDic[@"price"] floatValue];
                float newPrice = [dataDic[@"discountPrice"] floatValue];
//                _preferentialPrice = [NSString stringWithFormat:@"￥%0.2f",oldPrice-newPrice];
//                _payPrice = [NSString stringWithFormat:@"￥%0.2f",newPrice];
//                [self performSegueWithIdentifier:@"memoryListToPayVC" sender:self];
//                NSInteger preferentialPrice = (NSInteger)(oldPrice-newPrice);
                NSInteger payPrice = (NSInteger)newPrice;
                switch (payPrice) {
                    case 100:
                        [self validateIsCanBought:ProductID_Price100];
                        break;
                    case 150:
                        [self validateIsCanBought:ProductID_Price150];
                        break;
                    case 200:
                        [self validateIsCanBought:ProductID_Price200];
                        break;
                    case 250:
                        [self validateIsCanBought:ProductID_Price250];
                        break;
                    case 300:
                        [self validateIsCanBought:ProductID_Price300];
                        break;
                    case 350:
                        [self validateIsCanBought:@"jiyifa300"];
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
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
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
    [YHHud dismiss];
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
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

//交易完成后的操作
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易完成--------------");
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSData *transactionReceiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receipt = [transactionReceiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if ([productIdentifier length]>0) {
        //向自己的服务器验证购买凭证
        NSLog(@"----------%@",receipt);
    }
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receipt];//拼接请求数据
//    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//
//    //创建请求到苹果官方进行购买验证
//    NSURL *url=[NSURL URLWithString:kSandbox];//沙盒测试环境验证
////    NSURL *url=[NSURL URLWithString:kAppStore];//正式环境验证
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//    requestM.HTTPBody=bodyData;
//    requestM.HTTPMethod=@"POST";
//    //创建连接并发送同步请求
//    NSError *error=nil;
//    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
//    if (error) {
//        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
//        return;
//    }
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",dic);
//    if([dic[@"status"] intValue]==0){
//        NSLog(@"购买成功！");
//        NSDictionary *dicReceipt= dic[@"receipt"];
//        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
//        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
//        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        if ([productIdentifier isEqualToString:@"123"]) {
//            int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
//            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
//        }else{
//            [defaults setBool:YES forKey:productIdentifier];
//        }
//        //在此处对购买记录进行存储，可以存储到开发商的服务器端
//    }else{
//        NSLog(@"购买失败，未通过验证！");
//    }
    //移除transaction购买操作
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//交易失败后的操作
-(void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [YHHud showWithMessage:@"购买失败"];
    }else{
        [YHHud showWithMessage:@"用户取消交易"];
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

//--------------------------------------------内购结束-------------------------------------------------------
#pragma mark 邀请好友
- (void)invitateFriendClick{
    [_alertView dismissWithCompletion:^{
        [self performSegueWithIdentifier:@"memoryListToInviteRewards" sender:self];
    }];
}
#pragma mark 关闭提示框
- (void)closeClick{
    [_alertView dismissWithCompletion:nil];
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MemorySeriesToDetail"]) {
        MemoryDetailVC *detailVC = segue.destinationViewController;
        detailVC.delegate = self;
        detailVC.memory = _memory;
        NSDictionary *likesDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"];
        NSString *likeStatus = likesDic[_memory.memoryId];
        detailVC.isLike = ![likeStatus isEqualToString:@"0"];
    }else if ([segue.identifier isEqualToString:@"memoryListToPayVC"]){
        PayViewController *payVC = segue.destinationViewController;
        payVC.memoryId = _objectId;
        payVC.subType = _subType;
        payVC.inviteCount = _inviteCount;
        payVC.preferentialPrice = _preferentialPrice;
        payVC.payPrice = _payPrice;
        [YHSingleton shareSingleton].subType = _subType;
    }
}
- (void)reloadMemoryList{
    _pageIndex = 1;
    NSDictionary *jsonDic = @{
        @"userPhone": self.phoneNum,  // #用户手机号
        @"token": self.token,          //      #用户登陆凭证
        @"lessonId": _lessonId, // #记忆法系列ID
        @"pageIndex":[NSString stringWithFormat:@"%zd",_pageIndex]         //    #页数
    };
    [YHWebRequest YHWebRequestForPOST:kMemoryList parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"getMemoryList"];
            _memorySeriesList = [NSMutableArray arrayWithArray:resultArray];
            if ([self.phoneNum isEqualToString:@"13312345678"]) {
                _memorySeriesList = [NSMutableArray arrayWithObject:resultArray[0]];
            }
            [_tableView reloadData];
            NSInteger count = 0;
            for (NSInteger i = 0; i<_memorySeriesList.count; i++) {
                NSString *lastMemoryPayType = [NSString stringWithFormat:@"%@",_memorySeriesList[i][@"payType"]];
                if ([lastMemoryPayType isEqualToString:@"1"]) {
                    count++;
                }
            }
            if (count == _memorySeriesList.count) {
                _tableBottomSpace.constant = 0;
                [_bottomBgView removeFromSuperview];
            }
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)dealloc{
    //移除购买监听
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
@end
