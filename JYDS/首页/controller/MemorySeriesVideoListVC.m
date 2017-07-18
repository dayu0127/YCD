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

@interface MemorySeriesVideoListVC ()<UITableViewDelegate,UITableViewDataSource,MemoryDetailVCDelegate,SubAlertViewDelegate>
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
@property (copy,nonatomic) NSString *productId;
@end

@implementation MemorySeriesVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMemoryList) name:@"updateMemorySubStatus" object:nil];
    _lessonNameLabel.text = _lessonName;
    [self loadMemoryList];
    [_tableView registerNib:[UINib nibWithNibName:@"MemorySeriseCell" bundle:nil] forCellReuseIdentifier:@"MemorySeriseCell"];
    //监听购买结果
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
//- (void)addSubAllBtn{
//    _bottomBgView = [UIView new];
//    _bottomBgView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_bottomBgView];
//    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.mas_equalTo(@65);
//    }];
//    UIButton *subAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [subAllButton setTitle:@"邀请好友 领取优惠" forState:UIControlStateNormal];
//    [subAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    subAllButton.backgroundColor = ORANGERED;
//    subAllButton.layer.masksToBounds = YES;
//    subAllButton.layer.cornerRadius = 3.0f;
//    subAllButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    [subAllButton addTarget:self action:@selector(subAllClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomBgView addSubview:subAllButton];
//    [subAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_bottomBgView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
//    }];
//}
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
//                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"] == nil) {
//                    NSMutableDictionary *likesDic = [[NSMutableDictionary alloc] init];
//                    for (NSDictionary *dic in _memorySeriesList) {
//                        [likesDic setObject:@"0" forKey:dic[@"memoryId"]];
//                    }
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:likesDic] forKey:@"likesDic"];
//                }
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
    [cell.seriseImageView sd_setImageWithURL:[NSURL URLWithString:_memorySeriesList[indexPath.row][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"banner_defult"]];
    NSString *likesStr = [NSString convertWanFromNum:_memorySeriesList[indexPath.row][@"likes"]];
    cell.likesLabel.text = [NSString stringWithFormat:@"%@人点赞",likesStr];
    NSString *playCountStr = [NSString convertWanFromNum:_memorySeriesList[indexPath.row][@"views"]];
    cell.playCountLabel.text = [NSString stringWithFormat:@"%@次播放",playCountStr];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _memory = [Memory yy_modelWithJSON:_memorySeriesList[indexPath.row]];
    if ([_memory.payType isEqualToString:@"0"]) {
        [self subAlert:SubTypeMemorySingle];
    }else{
        [self performSegueWithIdentifier:@"MemorySeriesToDetail" sender:self];
    }
}
- (void)subAllClick:(UIButton *)sender {
    [self subAlert:SubTypeMemory];
}
#pragma mark 订阅弹窗
- (void)subAlert:(SubType)subType{
    _subType = subType;
    NSString *subAlertTitle;
    if (subType == SubTypeMemorySingle) {
        _objectId = _memory.memoryId;
        subAlertTitle = _memory.title;
    }else{
        _objectId = _lessonId;
        subAlertTitle = _lessonName;
    }
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,  //  #用户手机号
        @"memoryId":_objectId,       //  #目标id
        @"token":self.token       //   #登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kGetOrderSumPrice parameters:jsonDic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
            [subAlertView setTitle:subAlertTitle discountPrice:dataDic[@"discountPrice"] fullPrice:dataDic[@"full_price"] subType:_subType];
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
            [YHHud dismiss];
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _inviteCount = [NSString stringWithFormat:@"%@",dataDic[@"inviteNum"]];
                NSInteger discountPrice = [dataDic[@"discountPrice"] integerValue];
                NSInteger price = [dataDic[@"price"] integerValue];
                _preferentialPrice =[NSString stringWithFormat:@"%zd学习豆",price - discountPrice];
                _payPrice = [NSString stringWithFormat:@"%zd学习豆",discountPrice];
                [self performSegueWithIdentifier:@"memoryToPay" sender:self];
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
//        NSDictionary *likesDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"];
//        NSString *likeStatus = likesDic[_memory.memoryId];
//        detailVC.isLike = ![likeStatus isEqualToString:@"0"];
    }else if ([segue.identifier isEqualToString:@"memoryToPay"]){
        PayViewController *payVC = segue.destinationViewController;
        payVC.memoryId = _objectId;
        payVC.subType = _subType;
        payVC.inviteCount = _inviteCount;
        payVC.preferentialPrice = _preferentialPrice;
        payVC.payPrice = _payPrice;
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
//- (void)dealloc{
//    //移除购买监听
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//}
@end
