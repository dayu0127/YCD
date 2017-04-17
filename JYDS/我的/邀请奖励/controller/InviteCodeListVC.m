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
@property (strong,nonatomic) NSArray *inviteList;
@end

@implementation InviteCodeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    {
//        "userPhone":"******"        #用户手机号
//        "token":""                  #用户登陆凭证
//        "pageIndex":""             #页数
//    }
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,    //    #用户手机号
        @"token":self.token,            //      #用户登陆凭证
        @"pageIndex":@"1"         //    #页数
    };
    [YHWebRequest YHWebRequestForPOST:kInvitationList parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue]  == 106) {
            [self loadNoInviteView];
        }else if ([json[@"code"] integerValue]  == 200) {
            [self loadTableView];
            _jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _inviteList = _jsonData[@"invitationList"];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)loadNoInviteView{
    UILabel *label = [UILabel new];
    label.text = @"您还未邀请过小伙伴，快去邀请吧！";
    label.textColor = LIGHTGRAYCOLOR;
    label.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(289/667.0*HEIGHT);
        make.centerX.equalTo(self.view);
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
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _inviteList.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 140 : 42;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        InviteTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteTitleCell" forIndexPath:indexPath];
        cell.inviteNum.text = [NSString stringWithFormat:@"%@",_jsonData[@"invitationCount"]];
        return cell;
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
