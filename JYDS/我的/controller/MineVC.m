//
//  MineVC.m
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MineVC.h"
#import "TopCell.h"
#import "MineCell.h"
#import "ButtomCell.h"
#import "NoLoginHeaderView.h"
#import "LoggedInHeaderView.h"
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,LoggedInHeaderViewDelegate,ButtomCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *arr1;
@property (strong,nonatomic) NSArray *arr2;
@end

@implementation MineVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeaderView) name:@"updateHeaderView" object:nil];
}
- (void)updateHeaderView{
    LoggedInHeaderView *logged = [[LoggedInHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 187)];
    logged.delegate = self;
    _tableView.tableHeaderView = logged;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [_tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:nil] forCellReuseIdentifier:@"TopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ButtomCell" bundle:nil] forCellReuseIdentifier:@"ButtomCell"];
    _arr1 = @[@{@"img":@"mine_mysub",@"title":@"我的订阅"},
                  @{@"img":@"mine_collect",@"title":@"我的收藏"},
                  @{@"img":@"mine_invitation",@"title":@"邀请奖励"},
                  @{@"img":@"mine_training",@"title":@"右脑训练"}];
    _arr2 = @[@{@"img":@"mine_aboutus",@"title":@"关于我们"},
                  @{@"img":@"mine_feedback",@"title":@"意见反馈"}];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == YES) {
        LoggedInHeaderView *logged = [[LoggedInHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 187)];
        logged.delegate = self;
        _tableView.tableHeaderView = logged;
    }else{
        _tableView.tableHeaderView = [[NoLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 187)];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 4;
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
        return 75;
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
            cell.delegate = self;
            return cell;
        }
    }
}
- (void)pushToUserInfo{
    [self performSegueWithIdentifier:@"toUserInfo" sender:self];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//我的订阅
            [self performSegueWithIdentifier:@"toMySub" sender:self];
        }else if(indexPath.row == 1){//我的收藏
            [self performSegueWithIdentifier:@"toMyCollect" sender:self];
        }else if (indexPath.row == 2){
        
        }else{//右脑训练
            [self performSegueWithIdentifier:@"toExercises" sender:self];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"toAboutUs" sender:self];
        }else{
            [self performSegueWithIdentifier:@"toFeedback" sender:self];
        }
    }else if(indexPath.section == 3&&indexPath.row == 0){
        [self performSegueWithIdentifier:@"toSet" sender:self];
    }
}
- (void)telephoneClick{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *telephone = [UIAlertAction actionWithTitle:@"021-50725551" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"021-50725551"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:telephone];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
