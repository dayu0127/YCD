//
//  MineVC.m
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MineVC.h"
#import "TopHeaderView.h"
#import "TopCell.h"
#import "MineCell.h"
#import "ButtomCell.h"
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *arr1;
@property (strong,nonatomic) NSArray *arr2;
@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [_tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:nil] forCellReuseIdentifier:@"TopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ButtomCell" bundle:nil] forCellReuseIdentifier:@"ButtomCell"];
    _arr1 = @[@{@"img":@"mine_collect",@"title":@"我的收藏"},
                  @{@"img":@"mine_invitation",@"title":@"邀请奖励"},
                  @{@"img":@"mine_training",@"title":@"右脑训练"}];
    _arr2 = @[@{@"img":@"mine_aboutus",@"title":@"关于我们"},
                  @{@"img":@"mine_feedback",@"title":@"意见反馈"}];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 187)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:bgView.bounds];
    topImageView.image = [UIImage imageNamed:@"mine_top"];
    topImageView.userInteractionEnabled = YES;
    [bgView addSubview:topImageView];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.center = topImageView.center;
    loginButton.bounds = CGRectMake(0, 0, 103, 33);
    [loginButton setTitle:@"登录 / 注册" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3.0f;
    loginButton.layer.borderWidth = 1.0f;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:loginButton];
    _tableView.tableHeaderView = bgView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 3;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0? 0.000001: 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 38;
    }else if (indexPath.section==3&&indexPath.row ==1){
        return 69;
    }else{
        return 41;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)loginClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginVC];
    [app.window makeKeyWindow];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        TopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==1){
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:_arr1[indexPath.row][@"img"]];
        cell.tile.text = _arr1[indexPath.row][@"title"];
        return cell;
    }else if (indexPath.section==2){
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:_arr2[indexPath.row][@"img"]];
        cell.tile.text = _arr2[indexPath.row][@"title"];
        return cell;
    }else{
        if (indexPath.row == 0) {
            MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
            cell.img.image = [UIImage imageNamed:@"mine_setup"];
            cell.tile.text = @"设置";
            return cell;
        }else{
            ButtomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtomCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
