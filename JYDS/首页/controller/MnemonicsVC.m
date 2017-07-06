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
#import <StoreKit/StoreKit.h>
#import "GradeVC.h"
@interface MnemonicsVC ()<UITableViewDelegate,UITableViewDataSource,BannerCellDelegate,PlanCellDelegate,DynamicCellDelegate,SKStoreProductViewControllerDelegate>
@property (strong,nonatomic) NSArray *bannerInfoArray;
@property (strong,nonatomic) NSArray *dynamicArray;
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *memoryList;
@property (strong,nonatomic) Memory *memory;
@end

@implementation MnemonicsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //提示版本更新
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"https://itunes.apple.com/lookup?id=1230915498" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject[@"results"];
        if (array.count>0) {
            NSDictionary *dict = [array lastObject];
            NSString *appStoreVersion = dict[@"version"];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending){
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"版本有更新，请前去下载" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self presentToAppStore];
                }];
                UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //改变登录状态
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                    //跳转到登录页面
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
                    [app.window setRootViewController:loginVC];
                    [app.window makeKeyWindow];
                }];
                [alertVC addAction:canceAction];
                [alertVC addAction:updateAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
//        [YHHud showWithMessage:@"请求失败"];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//     [YHHud showWithMessage:@"提示"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PlanCell" bundle:nil] forCellReuseIdentifier:@"PlanCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryCell" bundle:nil] forCellReuseIdentifier:@"MemoryCell"];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexImages"];
    _dynamicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"][@"indexDynamic"];
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
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"toSignIn" sender:self];
    }
}
#pragma mark 消息按钮点击
- (IBAction)messageButtonClick:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"home_top_message"] forState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"homeToMessageCenter" sender:self];
}
#pragma mark 轮播图点击
- (void)bannerClick:(NSInteger)index{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
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
}
#pragma mark 最新动态点击
- (void)dynamicClick:(NSInteger)index{
    BaseNavViewController *dynamicVC = [[BaseNavViewController alloc] init];
    dynamicVC.linkUrl = _dynamicArray[index][@"content"];
    dynamicVC.shareUrl = _dynamicArray[index][@"content"];
    dynamicVC.navTitle = @"最新动态";
    dynamicVC.isShowShareBtn = YES;
    dynamicVC.isDynamic = YES;
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
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"homeToInviteRewards" sender:self];
    }
}
#pragma mark 课程记忆
- (void)pushToCourseMemory{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"homeToGradeList" sender:self];
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
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"toMemoryMore" sender:self];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if (token == nil && userInfo == nil) {
            [self returnToLogin];
        }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
            [self returnToBingingPhone];
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
    }else if ([segue.identifier isEqualToString:@"homeToGradeList"]){
        GradeVC *gradeVC = segue.destinationViewController;
        gradeVC.grade_type =@"1";
    }
}
- (void)presentToAppStore{
    //应用内跳转App Store
    //1:导入StoreKit.framework,控制器里面添加框架#import <StoreKit/StoreKit.h>
    //2:实现代理SKStoreProductViewControllerDelegate
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId
     @{SKStoreProductParameterITunesItemIdentifier : @"1214286729"} completionBlock:^(BOOL result, NSError *error) {
         //回调
         if(error){
             NSLog(@"错误%@",error);
         }else{
             //AS应用界面
             [self presentViewController:storeProductViewContorller animated:YES completion:nil];
         }
     }];
}
@end
