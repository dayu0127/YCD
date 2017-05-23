//
//  MnemonicsVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsVC.h"
#import <UIImageView+WebCache.h>
#import "BannerCell.h"
#import "PlanCell.h"
#import "MemoryHeaderView.h"
#import "DynamicCell.h"
#import "MemoryCell.h"
#import "Memory.h"
#import "MemoryDetailVC.h"
#import "BingingPhoneVC.h"
#import "BaseNavViewController.h"
#import "MemorySeriesVideoListVC.h"
@interface MnemonicsVC ()<UITableViewDelegate,UITableViewDataSource,BannerCellDelegate,PlanCellDelegate,DynamicCellDelegate>
@property (strong,nonatomic) NSArray *bannerInfoArray;
@property (strong,nonatomic) NSArray *dynamicArray;
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *memoryList;
@property (strong,nonatomic) Memory *memory;
@end

@implementation MnemonicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PlanCell" bundle:nil] forCellReuseIdentifier:@"PlanCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryCell" bundle:nil] forCellReuseIdentifier:@"MemoryCell"];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexImages"];
    _dynamicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexDynamic"];
    NSLog(@"%@",_dynamicArray);
    _memoryList = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexMemory"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //获取首页内容
            [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
            NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum!=nil ? [YHSingleton shareSingleton].userInfo.phoneNum : @"";
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]!=nil ? [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] : @"";
            NSDictionary *jsonDic = @{
                @"userPhone":phoneNum,      //  #用户手机号
                @"token":token        //    #用户登陆凭证
            };
            [YHWebRequest YHWebRequestForPOST:kBanner parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    _bannerInfoArray = dataDic[@"indexImages"];
                    _dynamicArray = dataDic[@"indexDynamic"];
                    _memoryList = dataDic[@"indexMemory"];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    [YHHud showWithMessage:json[@"message"]];
                    [self.tableView.mj_header endRefreshing];
                }
            }failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self.tableView.mj_header endRefreshing];
            }];
    }];
}
- (IBAction)signInClick:(UIButton *)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"toSignIn" sender:self];
    }
}
#pragma mark 消息按钮点击
- (IBAction)messageButtonClick:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"home_top_message"] forState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"homeToMessage" sender:self];
}
#pragma mark 轮播图点击
- (void)bannerClick:(NSInteger)index{
    BaseNavViewController *bannerVC = [[BaseNavViewController alloc] init];
    if (![_bannerInfoArray[index][@"content"] isEqualToString:@"#"]) {
        bannerVC.linkUrl = _bannerInfoArray[index][@"content"];
        bannerVC.shareUrl = _bannerInfoArray[index][@"content"];
        bannerVC.navTitle = @"返回";
        bannerVC.isShowShareBtn = YES;
        bannerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bannerVC animated:YES];
    }
}
#pragma mark 最新动态点击
- (void)dynamicClick:(NSInteger)index{
    BaseNavViewController *dynamicVC = [[BaseNavViewController alloc] init];
    dynamicVC.linkUrl = _dynamicArray[index][@"content"];
    dynamicVC.navTitle = @"最新动态";
    dynamicVC.isShowShareBtn = NO;
    dynamicVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 112/375.0*WIDTH;
        }else{
            return 70.0f;
        }
    }else if(indexPath.section == 1){
        return 177/355.0*(WIDTH-20)+42;
    }else{
        return 36/71.0*(WIDTH-20)+46;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.0001 : 41;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if(section ==1){
        return 1;
    }else{
        return _memoryList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerCell" forIndexPath:indexPath];
            [cell setScrollView:_bannerInfoArray];
            cell.delegete = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section == 1){
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
        [cell configScrollView:_dynamicArray];
        cell.delegete = self;
        return cell;
    }else{
        MemoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoryCell" forIndexPath:indexPath];
        [cell addModelWithDic:_memoryList[indexPath.row]];
        return cell;
    }
}
#pragma mark PlanCellDelegate
#pragma mark 右脑训练
- (void)pushToMySub{
    [self performSegueWithIdentifier:@"homeToExercises" sender:self];
}
#pragma mark 记忆法课程列表
- (void)pushToMemoryMore{
    [self pushMoreMemoryList];
}
#pragma mark 邀请好友
- (void)pushToInvitation{
    if (self.phoneNum==nil || (self.phoneNum != nil && ![self.phoneNum isEqualToString:@"13312345678"])) {
        [self performSegueWithIdentifier:@"homeToInviteRewards" sender:self];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        MemoryHeaderView *headerView = [MemoryHeaderView loadView];
        return headerView;
    }else if(section == 2){
        MemoryHeaderView *headerView = [MemoryHeaderView loadView];
        headerView.title.text = @"记忆法课程";
        return headerView;
    }else{
        return nil;
    }
}
#pragma mark 记忆法课程更多
- (void)pushMoreMemoryList{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"toMemoryMore" sender:self];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if ((self.associatedQq!=nil||self.associatedWx!=nil)&&token==nil) {
            [self returnToBingingPhone];
        }else if (self.token==nil&&self.phoneNum==nil) {
            [self returnToLogin];
        }else{
            _memory = [Memory yy_modelWithJSON:_memoryList[indexPath.row]];
            [self performSegueWithIdentifier:@"HometToSeries" sender:self];
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"HometToSeries"]) {
        MemorySeriesVideoListVC *seriesVC = segue.destinationViewController;
        seriesVC.lessonId = _memory.memoryId;
        seriesVC.lessonName = _memory.title;
        seriesVC.lessonPayType = _memory.payType;
    }
}
@end
