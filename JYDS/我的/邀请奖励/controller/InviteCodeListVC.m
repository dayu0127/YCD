//
//  InviteCodeListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/17.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "InviteCodeListVC.h"
#import "InviteTitleCell.h"
#import "InviteCell.h"
@interface InviteCodeListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSDictionary *jsonData;
@property (strong,nonatomic) NSMutableArray *inviteList;
@property (strong,nonatomic) InviteTitleCell *cell;
@property (assign,nonatomic) NSInteger pageIndex;
@end

@implementation InviteCodeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSDictionary *jsonDic = @{
//        @"userPhone":self.phoneNum,    //    #用户手机号
//        @"token":self.token,            //      #用户登陆凭证
//        @"pageIndex":@"1"         //    #页数
//    };
//    [YHWebRequest YHWebRequestForPOST:kInvitationList parameters:jsonDic success:^(NSDictionary *json) {
//        if ([json[@"code"] integerValue]  == 106) {
//            
//        }else if ([json[@"code"] integerValue]  == 200) {
//            [self loadTableView];
//            _jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
//            _inviteList = _jsonData[@"invitationList"];
//            [_tableView reloadData];
//        }else{
//            NSLog(@"%@",json[@"code"]);
//            [YHHud showWithMessage:json[@"message"]];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    [self loadTableView];
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
        @"token":self.token,            //      #用户登陆凭证
        @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex]         //    #页数
    };
    [YHWebRequest YHWebRequestForPOST:kInvitationList parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            _jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  _jsonData[@"invitationList"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                _tableView.alpha = 1;
                _inviteList = [NSMutableArray arrayWithArray:resultArray];
                [_tableView reloadData];
                if (status==UITableViewRefreshStatusHeader) {
                    _cell.inviteNum.text = [NSString stringWithFormat:@"%@",_jsonData[@"invitationCount"]];
                    [self.tableView.mj_header endRefreshing];
                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }else if (status == UITableViewRefreshStatusFooter){
                [_inviteList addObjectsFromArray:resultArray];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }else if([json[@"code"] integerValue] == 106){
            if (_inviteList.count == 0) {
                [self loadNoInviteView:@"您还未邀请过小伙伴，快去邀请吧！"];
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
- (void)loadTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"InviteTitleCell" bundle:nil] forCellReuseIdentifier:@"InviteTitleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"InviteCell" bundle:nil] forCellReuseIdentifier:@"InviteCell"];
    _tableView.alpha = 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _inviteList.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 140 : 42;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _cell = [tableView dequeueReusableCellWithIdentifier:@"InviteTitleCell" forIndexPath:indexPath];
        _cell.inviteNum.text = [NSString stringWithFormat:@"%@",_jsonData[@"invitationCount"]];
        return _cell;
    }else{
        InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell" forIndexPath:indexPath];
        cell.phoneNumLabel.text = _inviteList[indexPath.row-1][@"phone_num"];
        cell.preferentialLabel.text = _inviteList[indexPath.row-1][@"points"];
        return cell;
    }
}
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
