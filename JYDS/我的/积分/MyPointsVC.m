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
@property (strong,nonatomic) NSArray *pointsList;
@end

@implementation MyPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _pointsLabel.text = _points;
//    {
//        "userPhone":"******"        #用户手机号
//        "pageIndex":1               #页数
//        "token":""                  #用户登陆凭证
//    }
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,   //     #用户手机号
        @"pageIndex":@"1",          //     #页数
        @"token":self.token               //   #用户登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kPointsList parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 106) {
            [self loadNoPointsView];
        }else if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            [self loadTableView];
            _pointsList = jsonData[@"pointsList"];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
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
