//
//  WordSubedList.m
//  JYDS
//
//  Created by liyu on 2017/4/10.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordSubedList.h"
#import "SubedCell.h"
#import "Word.h"
#import "WordDetailVC.h"

@interface WordSubedList ()<UITableViewDelegate,UITableViewDataSource,WordDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *subedWordList;
@property (strong,nonatomic) Word *word;
@property (assign,nonatomic) NSInteger indexOfWord;
@property (assign,nonatomic) NSInteger pageIndex;
@end
@implementation WordSubedList

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [_tableView registerClass:[SubedCell class] forCellReuseIdentifier:@"SubedCell"];
}
- (void)loadDataWithRefreshStatus:(UITableViewRefreshStatus)status pageIndex:(NSInteger)pageIndex{
    if (status==UITableViewRefreshStatusAnimation) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{
        @"classId":_classId,    //  #版本ID
        @"unitId" :_unitId,    // #单元ID
        @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex],         //  #当前页数
        @"userPhone":self.phoneNum,     //  #用户手机号
        @"token":self.token       //   #登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kWordSubedList parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"subWordList"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                _subedWordList = [NSMutableArray arrayWithArray:resultArray];
                [self.tableView reloadData];
                if (status==UITableViewRefreshStatusHeader) {
                    [self.tableView.mj_header endRefreshing];
                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }else if (status == UITableViewRefreshStatusFooter){
                [_subedWordList addObjectsFromArray:resultArray];
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
    return _subedWordList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
    [cell addModelWithDic:_subedWordList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexOfWord = indexPath.row+1;
    _word = [Word yy_modelWithJSON:_subedWordList[indexPath.row]];
    [self performSegueWithIdentifier:@"toWordSubedDetail" sender:self];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toWordSubedDetail"]) {
        WordDetailVC *wordDetailVC = segue.destinationViewController;
        wordDetailVC.delegate = self;
        wordDetailVC.word = _word;
        wordDetailVC.showCollectButton = YES;
        wordDetailVC.indexOfWord = _indexOfWord;
        wordDetailVC.wordNum = _wordNum;
        wordDetailVC.vcName = UIViewControllerNameWordSubedList;
    }
}
- (void)updateWordList{
    _pageIndex = 1;
    [self loadDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
}
@end
