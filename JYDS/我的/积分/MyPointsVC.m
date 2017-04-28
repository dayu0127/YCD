//
//  MyPointsVC.m
//  JYDS
//
//  Created by liyu on 2017/4/18.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MyPointsVC.h"
#import "MyPointsCell.h"
@interface MyPointsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *pointsList;
@property (strong,nonatomic) NSDictionary *jsonData;
@property (assign,nonatomic) NSInteger pageIndex;
@end

@implementation MyPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _pointsLabel.text = _points;
////    {
////        "userPhone":"******"        #用户手机号
////        "pageIndex":1               #页数
////        "token":""                  #用户登陆凭证
////    }
//    NSDictionary *jsonDic = @{
//        @"userPhone":self.phoneNum,   //     #用户手机号
//        @"pageIndex":@"1",          //     #页数
//        @"token":self.token               //   #用户登陆凭证
//    };
//    [YHWebRequest YHWebRequestForPOST:kPointsList parameters:jsonDic success:^(NSDictionary *json) {
//        if ([json[@"code"] integerValue] == 106) {
//            [self loadNoPointsView];
//        }else if ([json[@"code"] integerValue] == 200) {
//            NSDictionary *jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
//            [self loadTableView];
//            _pointsList = jsonData[@"pointsList"];
//            [_tableView reloadData];
//        }else{
//            NSLog(@"%@",json[@"code"]);
//            [YHHud showWithMessage:json[@"message"]];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
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
    [YHWebRequest YHWebRequestForPOST:kPointsList parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            _jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  _jsonData[@"pointsList"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                self.tableView.alpha = 1;
                _pointsList = [NSMutableArray arrayWithArray:resultArray];
                [_tableView reloadData];
                if (status==UITableViewRefreshStatusHeader) {
                   _pointsLabel.text = [NSString stringWithFormat:@"%@",_jsonData[@"countPoints"]];
                    [self.tableView.mj_header endRefreshing];
                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }else if (status == UITableViewRefreshStatusFooter){
                [_pointsList addObjectsFromArray:resultArray];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }else if([json[@"code"] integerValue] == 106){
            if (_pointsList.count==0) {
                [self loadNoPointsView];
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
- (void)loadNoPointsView{
    UILabel *label = [UILabel new];
    label.text = @"您当前无积分！";
    label.textColor = LIGHTGRAYCOLOR;
    label.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:label];
    CGFloat y = CGRectGetMaxY(_topView.frame);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(y+122);
        make.centerX.equalTo(self.view);
    }];
}
- (void)loadTableView{
    CGFloat y = CGRectGetMaxY(_topView.frame);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, WIDTH, HEIGHT-y) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"MyPointsCell" bundle:nil] forCellReuseIdentifier:@"MyPointsCell"];
    _tableView.alpha = 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pointsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPointsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPointsCell" forIndexPath:indexPath];
    cell.dateLabel.text  = _pointsList[indexPath.row][@"create_time"];
    cell.titleLabel1.text  = _pointsList[indexPath.row][@"title"];
    cell.pointsLabel.text  = [NSString stringWithFormat:@"+%@",_pointsList[indexPath.row][@"points"]];
    return cell;
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
