//
//  MyMemorySubedVC.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MyMemorySubedVC.h"
#import "MemoryMoreCell.h"
#import "Memory.h"
#import "MemoryDetailVC.h"
@interface MyMemorySubedVC ()<UITableViewDelegate,UITableViewDataSource,MemoryDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *memoryVideoList;
@property (strong,nonatomic) Memory *memory;
@property (assign,nonatomic) NSInteger pageIndex;
@end

@implementation MyMemorySubedVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadMemoryList:1];
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
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryMoreCell" bundle:nil] forCellReuseIdentifier:@"MemoryMoreCell"];
}
//- (void)loadMemoryList:(NSInteger)index{
//    //    {
//    //        "userPhone":"*****",        #用户手机号
//    //        "token":"*****",            #登陆凭证
//    //        "pageIndex":1               #记忆法页数
//    //    }
//    if (index == 1) {
//        [YHHud showWithStatus];
//    }
//    NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,    //    #用户手机号
//                              @"token":self.token,         //   #登陆凭证
//                              @"pageIndex":@"1",        //   #记忆法页数
//                              @"type":@"1"};       //  #查询类型 0所有 1已订阅
//    [YHWebRequest YHWebRequestForPOST:kMemoryVideo parameters:jsonDic success:^(NSDictionary *json) {
//        if (index == 1) {
//            [YHHud dismiss];
//        }
//        if ([json[@"code"] integerValue] == 200) {
//            NSArray *resultArr = [NSDictionary dictionaryWithJsonString:json[@"data"]][@"indexMemory"];
//            _memoryVideoList = [NSMutableArray array];
//            for (NSDictionary *memoryDic in resultArr) {
//                if ([memoryDic[@"payType"] integerValue] == 1) {
//                    [_memoryVideoList addObject:memoryDic];
//                }
//            }
//            [_tableView reloadData];
//        }else{
//            NSLog(@"%@",json[@"code"]);
//            [YHHud showWithMessage:json[@"message"]];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        if (index == 1) {
//            [YHHud dismiss];
//        }
//        NSLog(@"%@",error);
//    }];
//}
- (void)loadDataWithRefreshStatus:(UITableViewRefreshStatus)status pageIndex:(NSInteger)pageIndex{
    if (status==UITableViewRefreshStatusAnimation) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,    //    #用户手机号
        @"token":self.token,         //   #登陆凭证
        @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex],        //   #记忆法页数
        @"type":@"1"       //  #查询类型 0所有 1已订阅
    };
    [YHWebRequest YHWebRequestForPOST:kMemoryVideo parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"indexMemory"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                _memoryVideoList = [NSMutableArray arrayWithArray:resultArray];
                [_tableView reloadData];
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
            if (_pageIndex==1) {
                [self loadNoInviteView:@"您还未订阅记忆法，快去订阅吧！"];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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
    [self performSegueWithIdentifier:@"MySubToMemoryDetail" sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MySubToMemoryDetail"]) {
        MemoryDetailVC *detailVC = segue.destinationViewController;
        detailVC.memory = _memory;
        detailVC.delegate = self;
    }
}
- (void)reloadMemoryList{
//    [self loadMemoryList:0];
    _pageIndex = 1;
    [self loadDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
}

@end
