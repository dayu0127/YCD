//
//  PayViewController.m
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "PayViewController.h"
#import "PaymentCell.h"
#import "PayDetailCell.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "BeanPayVC.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,PayDetailCellDelegate,BeanPayVCDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inviteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferentialPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MJRefreshNormalHeader *header;
@property (strong,nonatomic) PayDetailCell *cell;
//@property (assign,nonatomic) NSInteger isReview;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"back" object:nil];
    [self getBean];
    //下拉刷新
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //    {
        //        "userPhone":"******"    #用户手机号
        //        "token":"****"          #登陆凭证
        //        "objectId":"****"       #目标id
        //        "payType":"***"         #支付类型 1：记忆法  0：单词课本
        //    }
        NSString *payType;
        NSString *objectId;
        if (_subType == SubTypeWord) {    //单词订阅参数
            payType = @"0";
            objectId = _classId;
        }else if (_subType == SubTypeMemory) { //记忆法课程订阅参数
            payType = @"1";
            objectId = _memoryId;
        }else{
            payType = @"2";
            objectId = _memoryId;
        }
        NSDictionary *jsonDic  = @{
            @"userPhone":self.phoneNum,  //  #用户手机号
            @"payType" :payType,         //   #购买类型
            @"objectId":objectId,       //  #目标id
            @"token":self.token       //   #登陆凭证
        };
        [YHWebRequest YHWebRequestForPOST:kOrderPrice parameters:jsonDic success:^(NSDictionary *json) {
            [self.tableView.mj_header endRefreshing];
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _cell.inviteCountLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"inviteNum"]];
                NSInteger discountPrice = [dataDic[@"discountPrice"] integerValue];
                NSInteger price = [dataDic[@"price"] integerValue];
                _cell.preferentialPriceLabel.text =[NSString stringWithFormat:@"%zd学习豆",price - discountPrice];
                _cell.payPriceLabel.text = [NSString stringWithFormat:@"%zd学习豆",discountPrice];
                [self getBean];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            NSLog(@"%@",error);
        }];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    _header.lastUpdatedTimeLabel.hidden = YES;
    // 设置菊花样式
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // 设置header
    self.tableView.mj_header = _header;
    [_tableView registerNib:[UINib nibWithNibName:@"PayDetailCell" bundle:nil] forCellReuseIdentifier:@"PayDetailCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:@"PaymentCell"];
}
- (void)getBean{
    NSDictionary *jsonDic  = @{
        @"userPhone":self.phoneNum,    //    #用户手机号
        @"token":self.token  // #登陆后的token值
    };
    [YHWebRequest YHWebRequestForPOST:kGetUser parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _cell.myBeanLabel.text = [NSString stringWithFormat:@"%@",jsonDic[@"user"][@"stuBean"]];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)back{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 252;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"PayDetailCell" forIndexPath:indexPath];
    _cell.inviteCountLabel.text = _inviteCount;
    _cell.preferentialPriceLabel.text = _preferentialPrice;
    _cell.payPriceLabel.text = _payPrice;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.myBeanLabel.text = [NSString stringWithFormat:@"%@",[YHSingleton shareSingleton].userInfo.stuBean];
    _cell.delegate = self;
    return _cell;
}
- (NSDictionary *)getJsonDic{
    NSMutableDictionary *baseDic = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"userPhone":self.phoneNum,   //    #用户手机号
        @"token":self.token,      //    #登陆凭证
    }];
    if (_subType == SubTypeWord) {
        [baseDic setObject:@"0" forKey:@"type"];
        [baseDic setObject:_classId forKey:@"classId"];
    }else if (_subType == SubTypeMemory) {
        [baseDic setObject:@"1" forKey:@"type"];
        [baseDic setObject:_memoryId forKey:@"lessonId"];
    }else {
        [baseDic setObject:@"2" forKey:@"type"];
        [baseDic setObject:_memoryId forKey:@"lessonId"];
    }
    return [NSDictionary dictionaryWithDictionary:baseDic];
}
- (void)surePayClick{
    NSString *message = [NSString stringWithFormat:@"确定支付%@?",_cell.payPriceLabel.text];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *jsonDic = [self getJsonDic];
        [YHWebRequest YHWebRequestForPOST:kStuBeanPay parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                //刷新订阅状态
                if (_subType == SubTypeWord) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWordSubStatus" object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMemorySubStatus" object:nil];
                }
                [self.navigationController popViewControllerAnimated:YES];
                [YHHud showPaySuccessOrFailed:@"success"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [YHHud dismiss];
                });
            }else if ([json[@"code"] integerValue] == 106){
                [YHHud showWithMessage:json[@"message"]];
            }else{
                NSLog(@"%@",json[@"code"]);
                NSLog(@"%@",json[@"message"]);
                [YHHud showPaySuccessOrFailed:@"failed"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [YHHud dismiss];
                });
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [YHHud showWithMessage:@"网络异常,支付失败"];
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)beanPayClick{
    [self performSegueWithIdentifier:@"toBeanPay" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toBeanPay"]) {
        BeanPayVC *payVC = segue.destinationViewController;
        payVC.delegate = self;
    }
}
- (void)updateBean:(NSString *)bean{
    _cell.myBeanLabel.text = bean;
}
@end
