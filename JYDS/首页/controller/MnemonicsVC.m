//
//  MnemonicsVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsVC.h"
#import <SDCycleScrollView.h>
#import "MemoryCourseVC.h"
#import "BannerDetailVC.h"
#import <UIImageView+WebCache.h>
#import "BannerCell.h"
#import "PlanCell.h"
#import "MemoryHeaderView.h"
#import "DynamicCell.h"
#import "MemoryCell.h"
#import "PayVC.h"

@interface MnemonicsVC ()<UITableViewDelegate,UITableViewDataSource>
//@property (strong,nonatomic) NSMutableArray *netImages;  //网络图片
//@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;//轮播器
//@property (strong, nonatomic) UITableView *tableView;
//@property (strong,nonatomic) JCAlertView *alertView;
//@property (strong,nonatomic) NSArray *bannerInfoArray;
//@property (weak, nonatomic) IBOutlet UIView *buttomBgView;
//@property (weak, nonatomic) IBOutlet UILabel *subLabel;
//@property (weak, nonatomic) IBOutlet UIButton *subBtn;
//@property (strong,nonatomic) NSArray *memoryArray;
//@property (assign,nonatomic) BOOL isHiddenNav;
//@property (strong,nonatomic) MJRefreshNormalHeader *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MnemonicsVC
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PlanCell" bundle:nil] forCellReuseIdentifier:@"PlanCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryCell" bundle:nil] forCellReuseIdentifier:@"MemoryCell"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
//    [self initNaBar:@"记忆大师"];
//    [self nightModeConfiguration];
//    _netImages = [NSMutableArray array];
//    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
//    for (NSDictionary *dic in _bannerInfoArray) {
//        [_netImages addObject:[NSString stringWithFormat:@"%@",dic[@"topImageUrl"]]];
//    }
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self initTableView];
}
//- (void)nightModeConfiguration{
//    _buttomBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
//    _buttomBgView.alpha = 0;
//    _subLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
//    _subBtn.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
//}
//- (void)dayMode{
//    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
//    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
//    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//}
//- (void)nightMode{
//    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
//    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
//    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//}
#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    BannerDetailVC *bannerVC = [[BannerDetailVC alloc] init];
//    bannerVC.navTitle = _bannerInfoArray[index][@"topTitle"];
//    bannerVC.linkUrl = _bannerInfoArray[index][@"linkUrl"];
//    bannerVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:bannerVC animated:YES];
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 112/375.0*WIDTH;
        }else{
            return 70.0f;
        }
    }else if(indexPath.section == 1){
        return 218.0f;
    }else{
        return 260;
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
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section == 1){
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
        return cell;
    }else{
        MemoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoryCell" forIndexPath:indexPath];
        cell.memoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"k%zd",indexPath.row+1]];
        return cell;
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
//- (void)initTableView{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-113) style:UITableViewStyleGrouped];
//    _tableView.delegate = self;
//    _tableView.dataSource =  self;
//    _tableView.rowHeight = 100;
//    _tableView.separatorInset = UIEdgeInsetsZero;
//    _tableView.backgroundColor = [UIColor clearColor];
//    [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
//    [self.view addSubview:_tableView];
//    //下拉刷新
//    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSDictionary *dic = [NSDictionary dictionary];
//        if ([YHSingleton shareSingleton].userInfo == nil) {
//            dic = @{@"userID":@"-1",@"device_id":@"0"};
//        }else{
//            dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
//        }
//        [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
//            [self.tableView.mj_header endRefreshing];
//            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//                [self returnToLogin];
//            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                _memoryArray = json[@"data"];
//                [self.tableView reloadData];
//            }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                [YHHud showWithMessage:@"服务器错误"];
//            }else{
//                [YHHud showWithMessage:@"数据异常"];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            [self.tableView.mj_header endRefreshing];
//            [YHHud showWithMessage:@"数据请求失败"];
//        }];
//    }];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    _header.automaticallyChangeAlpha = YES;
//    // 隐藏时间
//    _header.lastUpdatedTimeLabel.hidden = YES;
//    // 设置菊花样式
//    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
//        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    }else{
//        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    }
//    // 设置header
//    self.tableView.mj_header = _header;
//    // 加载数据
//    [self reloadMemoryList];
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _memoryArray.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MnemonicsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MnemonicsCell" forIndexPath:indexPath];
//    [cell addModelWithDic:_memoryArray[indexPath.row]];
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 9/16.0*WIDTH;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.000001;
//}
//#pragma tableView代理方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MemoryCourseVC *courseVC = [[MemoryCourseVC alloc] init];
//    courseVC.hidesBottomBarWhenPushed = YES;
//    courseVC.memoryArray = _memoryArray;
//    courseVC.memory = [Mnemonics yy_modelWithJSON:_memoryArray[indexPath.row]];
//    courseVC.delegate = self;
//    _isHiddenNav = NO;
//    [self.navigationController pushViewController:courseVC animated:YES];
//}
//- (void)reloadMemoryList{
//    NSDictionary *dic = [NSDictionary dictionary];
//    if ([YHSingleton shareSingleton].userInfo == nil) {
//        dic = @{@"userID":@"-1",@"device_id":@"0"};
//    }else{
//        dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
//    }
//    [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//            [self returnToLogin];
//        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            _memoryArray = json[@"data"];
//            [_tableView reloadData];
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"数据异常"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [YHHud showWithMessage:@"数据请求失败"];
//    }];
//}
//#pragma mark 轮播图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 9/16.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
//    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
//        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
//        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
//    }else{
//        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
//        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
//    }
//    self.cycleScrollView.imageURLStringsGroup = self.netImages;
//    self.cycleScrollView.autoScrollTimeInterval = 3.0f;
//    return _cycleScrollView;
//}
//#pragma mark 订阅所有记忆法
//- (IBAction)subscribe:(id)sender {
//    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:@"如果确定，将一次订阅所有记忆法课程"];
//    alertView.delegate = self;
//    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
//    [_alertView show];
//}
//- (NSInteger)getTotalPrice{
//    NSInteger totalPrice = 0;
//    for (NSDictionary *item in _memoryArray) {
//        if ([item[@"coursePayStatus"] integerValue] == 0) {
//            totalPrice = totalPrice + [item[@"coursePrice"] integerValue];
//        }
//    }
//    return totalPrice;
//}
//- (void)buttonClickIndex:(NSInteger)buttonIndex{
//    [_alertView dismissWithCompletion:nil];
//    if (buttonIndex == 1) {
//        //学习豆不足
//        if ([self getTotalPrice]>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
//            [YHHud showWithMessage:@"余额不足"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                _isHiddenNav = YES;
//                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
//                payVC.isHiddenNav = YES;
//                [self.navigationController pushViewController:payVC animated:YES];
//            });
//        }else{
//            //学习豆充足
//            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"type":@"memory",@"device_id":DEVICEID};
//            [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
//                if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//                    [self returnToLogin];
//                }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                    _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-113);
//                    _buttomBgView.alpha = 0;
//                    NSMutableArray *arr = [NSMutableArray arrayWithArray:_memoryArray];
//                    for (NSInteger i = 0; i<arr.count; i++) {
//                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:i]];
//                        [dic setObject:[NSNumber numberWithInt:1] forKey:@"coursePayStatus"];
//                        [arr replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
//                    }
//                    _memoryArray = [NSArray arrayWithArray:arr];
//                    [_tableView reloadData];
//                    [YHHud showWithSuccess:@"订阅成功"];
//                    [self updateCostBean];
//                }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                    [YHHud showWithMessage:@"服务器错误"];
//                }else{
//                    [YHHud showWithMessage:@"订阅失败"];
//                }
//            } failure:^(NSError * _Nonnull error) {
//                [YHHud showWithMessage:@"数据请求失败"];
//            }];
//        }
//    }
//    
//}
//#pragma mark 更新用户的消费学习豆
//- (void)updateCostBean{
//    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            [YHSingleton shareSingleton].userInfo.costStudyBean = [NSString stringWithFormat:@"%@",json[@"data"][@"consumeBean"]];
//            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"数据异常"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [YHHud showWithMessage:@"数据请求失败"];
//    }];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if (_isHiddenNav == YES) {
//        self.navigationController.navigationBar.hidden = NO;
//    }
//}
@end
