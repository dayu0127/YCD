//
//  MnemonicsVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsVC.h"
#import <SDCycleScrollView.h>
#import "BannerDetailVC.h"
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
@interface MnemonicsVC ()<UITableViewDelegate,UITableViewDataSource,BannerCellDelegate,PlanCellDelegate,DynamicCellDelegate,MemoryHeaderViewDelegate>
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
    _memoryList = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexMemory"];
}
- (IBAction)signInClick:(UIButton *)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if ((self.associatedQq!=nil||self.associatedWx!=nil)&&token==nil) {
        [self returnToBingingPhone];
    }else if (self.token==nil&&self.phoneNum==nil) {
        [self returnToLogin];
    }else{
        [self performSegueWithIdentifier:@"toSignIn" sender:self];
    }
}
#pragma mark 轮播图点击
- (void)bannerClick:(NSInteger)index{
    BaseNavViewController *bannerVC = [[BaseNavViewController alloc] init];
    bannerVC.linkUrl = _bannerInfoArray[index][@"content"];
    bannerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerVC animated:YES];
}
- (void)dynamicClick:(NSInteger)index{
    BaseNavViewController *bannerVC = [[BaseNavViewController alloc] init];
    bannerVC.linkUrl = _dynamicArray[index][@"content"];
    bannerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerVC animated:YES];
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
        return 36/71.0*(WIDTH-20)+86;
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
        cell.delegete = self;
        return cell;
    }else{
        MemoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoryCell" forIndexPath:indexPath];
        cell.memoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"k%zd",indexPath.row+1]];
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
    [self performSegueWithIdentifier:@"homeToInviteRewards" sender:self];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        MemoryHeaderView *headerView = [MemoryHeaderView loadView];
        headerView.moreButton.alpha = 0;
        headerView.arrows.alpha = 0;
        return headerView;
    }else if(section == 2){
        MemoryHeaderView *headerView = [MemoryHeaderView loadView];
        headerView.title.text = @"记忆法课程";
        headerView.delegate = self;
        return headerView;
    }else{
        return nil;
    }
}
#pragma mark 记忆法课程更多
- (void)pushMoreMemoryList{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if ((self.associatedQq!=nil||self.associatedWx!=nil)&&token==nil) {
        [self returnToBingingPhone];
    }else if (self.token==nil&&self.phoneNum==nil) {
        [self returnToLogin];
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
            [self performSegueWithIdentifier:@"toMemoryMore" sender:self];
        }
    }
}
@end
