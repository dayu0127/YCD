//
//  MemoryListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/11.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryListVC.h"
#import "MemoryMoreCell.h"
#import "MemoryDetailVC.h"
#import "Memory.h"
#import "SubAlertView.h"
#import "PayViewController.h"
#import "UILabel+Utils.h"
#import "BaseNavViewController.h"
#import "MemorySeriesVideoListVC.h"
@interface MemoryListVC ()<UITableViewDelegate,UITableViewDataSource,SubAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *memoryVideoList;
@property (strong,nonatomic) Memory *memory;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *inviteCount;
@property (copy,nonatomic) NSString *preferentialPrice;
@property (copy,nonatomic) NSString *payPrice;
@property (assign,nonatomic) NSInteger pageIndex;

@end

@implementation MemoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMemoryList) name:@"updateMemorySubStatus" object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introduceClick)];
    [_topImageView addGestureRecognizer:tap];
    [self loadMemoryList];
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryMoreCell" bundle:nil] forCellReuseIdentifier:@"MemoryMoreCell"];
}
- (void)introduceClick{
    BaseNavViewController *dynamicVC = [[BaseNavViewController alloc] init];
    dynamicVC.linkUrl = kMemoryIntroduce;
    dynamicVC.navTitle = @"记忆法简介";
    dynamicVC.isShowShareBtn = NO;
    dynamicVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicVC animated:YES];
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
        @"userPhone":self.phoneNum,    //    #用户手机号
        @"token":self.token,         //   #登陆凭证
        @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex],         //    #页数
        @"type":@"0"       //  #查询类型 0所有 1已订阅
    };
    [YHWebRequest YHWebRequestForPOST:kMemoryVideo parameters:jsonDic success:^(NSDictionary *json) {
        if (status == UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"indexMemory"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                _memoryVideoList = [NSMutableArray arrayWithArray:resultArray];
                [_tableView reloadData];
                //本地保存视频是否被点赞
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"] == nil) {
                    NSMutableDictionary *likesDic = [[NSMutableDictionary alloc] init];
                    for (NSDictionary *dic in _memoryVideoList) {
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
                [_memoryVideoList addObjectsFromArray:resultArray];
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
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _memoryVideoList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH*182/375.0+39;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemoryMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoryMoreCell" forIndexPath:indexPath];
    [cell addModelWithDic:_memoryVideoList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _memory = [Memory yy_modelWithJSON:_memoryVideoList[indexPath.row]];
    if ([_memory.payType isEqualToString:@"0"]) {
        SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
        [subAlertView setTitle:_memory.title fullPrice:_memory.full_price subType:SubTypeMemory];
        subAlertView.label_0_height.constant = [subAlertView.label_0.text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0f] forKey:NSFontAttributeName] context:nil].size.height+6;
        subAlertView.delegate = self;
        _alertView = [[JCAlertView alloc] initWithCustomView:subAlertView dismissWhenTouchedBackground:NO];
        [_alertView show];
    }else{
        [self performSegueWithIdentifier:@"MemoryListToSeries" sender:self];
    }
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
            @"payType" :@"1",         //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
            @"objectId":_memory.memoryId,       //  #目标id
            @"token":self.token       //   #登陆凭证
        };
        [YHWebRequest YHWebRequestForPOST:kOrderPrice parameters:jsonDic success:^(NSDictionary *json) {
            [YHHud dismiss];
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _inviteCount = [NSString stringWithFormat:@"%@",dataDic[@"inviteNum"]];
                float oldPrice = [dataDic[@"price"] floatValue];
                float newPrice = [dataDic[@"discountPrice"] floatValue];
                _preferentialPrice = [NSString stringWithFormat:@"￥%0.2f",oldPrice-newPrice];
                _payPrice = [NSString stringWithFormat:@"￥%0.2f",newPrice];
                [self performSegueWithIdentifier:@"memoryListToPayVC" sender:self];
            }else{
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MemoryListToSeries"]) {
        MemorySeriesVideoListVC *seriesVC = segue.destinationViewController;
        seriesVC.lessonId = _memory.memoryId;
    }else if ([segue.identifier isEqualToString:@"memoryListToPayVC"]){
        PayViewController *payVC = segue.destinationViewController;
        payVC.memoryId = _memory.memoryId;
        payVC.payType = @"1";  // #购买类型 0：K12课程单词购买 1：记忆法课程购买
        payVC.inviteCount = _inviteCount;
        payVC.preferentialPrice = _preferentialPrice;
        payVC.payPrice = _payPrice;
        [YHSingleton shareSingleton].payType = @"1";
    }
}
- (void)reloadMemoryList{
    _pageIndex = 1;
    [self loadDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
}
@end
