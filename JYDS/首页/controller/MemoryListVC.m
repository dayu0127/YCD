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
#import "UILabel+Utils.h"
#import "BaseNavViewController.h"
#import "MemorySeriesVideoListVC.h"
@interface MemoryListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *memoryVideoList;
@property (strong,nonatomic) Memory *memory;
@property (strong,nonatomic) JCAlertView *alertView;
@property (assign,nonatomic) NSInteger pageIndex;

@end

@implementation MemoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
        @"type":@"0"
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
//                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"] == nil) {
//                    NSMutableDictionary *likesDic = [[NSMutableDictionary alloc] init];
//                    for (NSDictionary *dic in _memoryVideoList) {
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
    [self performSegueWithIdentifier:@"MemoryListToSeries" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MemoryListToSeries"]) {
        MemorySeriesVideoListVC *seriesVC = segue.destinationViewController;
        seriesVC.lessonId = _memory.memoryId;
        seriesVC.lessonName = _memory.title;
        seriesVC.lessonPayType = _memory.payType;
        seriesVC.isQueryAllSub = NO;
    }
}
//- (void)reloadMemoryList{
//    _pageIndex = 1;
//    [self loadDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
//}
@end
