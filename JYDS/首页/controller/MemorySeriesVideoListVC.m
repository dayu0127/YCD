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
@interface MemorySeriesVideoListVC ()<UITableViewDelegate,UITableViewDataSource,MemoryDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) Memory *memory;
@property (strong,nonatomic) NSMutableArray *memorySeriesList;
@property (assign,nonatomic) NSInteger pageIndex;
@end

@implementation MemorySeriesVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMemoryList];
    [_tableView registerNib:[UINib nibWithNibName:@"MemorySeriseCell" bundle:nil] forCellReuseIdentifier:@"MemorySeriseCell"];
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
                [_tableView reloadData];
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
    NSString *likesStr = [NSString convertWanFromNum:_memorySeriesList[indexPath.row][@"likes"]];
    cell.likesLabel.text = [NSString stringWithFormat:@"%@人点赞",likesStr];
    NSString *playCountStr = [NSString convertWanFromNum:_memorySeriesList[indexPath.row][@"views"]];
    cell.playCountLabel.text = [NSString stringWithFormat:@"%@次播放",playCountStr];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _memory = [Memory yy_modelWithJSON:_memorySeriesList[indexPath.row]];
    [self performSegueWithIdentifier:@"MemorySeriesToDetail" sender:self];
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
    }
}
- (void)reloadMemoryList{
    _pageIndex = 1;
    [self loadDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
}
@end
