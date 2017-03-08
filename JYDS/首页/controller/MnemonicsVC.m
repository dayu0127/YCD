//
//  MnemonicsVC.m
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsVC.h"
#import <SDCycleScrollView.h>
#import "MnemonicsCell.h"
#import "MemoryCourseVC.h"
#import "BannerDetailVC.h"
#import "Mnemonics.h"
#import <UIImageView+WebCache.h>
#import "PayVC.h"

@interface MnemonicsVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate,MemoryCourseVCDelegate>
@property (strong,nonatomic) NSMutableArray *netImages;  //网络图片
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;//轮播器
@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic) JCAlertView *alertView;
@property (strong,nonatomic) NSArray *bannerInfoArray;
@property (weak, nonatomic) IBOutlet UIView *buttomBgView;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (strong,nonatomic) NSArray *memoryArray;
@property (assign,nonatomic) BOOL isHiddenNav;
@property (strong,nonatomic) MJRefreshNormalHeader *header;

@end

@implementation MnemonicsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
    [self initNaBar:@"记忆大师"];
    [self nightModeConfiguration];
    _netImages = [NSMutableArray array];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
    for (NSDictionary *dic in _bannerInfoArray) {
        NSMutableString *imageUrlStr = [NSMutableString stringWithString:dic[@"topImageUrl"]];
        [imageUrlStr replaceCharactersInRange:[imageUrlStr rangeOfString:@"http"] withString:@"https"];
        [_netImages addObject:[NSString stringWithFormat:@"%@",imageUrlStr]];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];
}
- (void)nightModeConfiguration{
//    _buttomBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _buttomBgView.alpha = 0;
    _subLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subBtn.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)dayMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}
- (void)nightMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}
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
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-113) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =  self;
    _tableView.rowHeight = 100;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
    [self.view addSubview:_tableView];
    //下拉刷新
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
        [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
            [self.tableView.mj_header endRefreshing];
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                _memoryArray = json[@"data"];
                [self.tableView reloadData];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"数据异常"];
            }
        } failure:^(NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            [YHHud showWithMessage:@"数据请求失败"];
        }];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    _header.lastUpdatedTimeLabel.hidden = YES;
    // 设置菊花样式
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }else{
        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    // 设置header
    self.tableView.mj_header = _header;
    // 加载数据
    [self reloadMemoryList];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _memoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MnemonicsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MnemonicsCell" forIndexPath:indexPath];
    [cell addModelWithDic:_memoryArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9/16.0*WIDTH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
#pragma tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemoryCourseVC *courseVC = [[MemoryCourseVC alloc] init];
    courseVC.hidesBottomBarWhenPushed = YES;
    courseVC.memoryArray = _memoryArray;
    courseVC.memory = [Mnemonics yy_modelWithJSON:_memoryArray[indexPath.row]];
    courseVC.delegate = self;
    _isHiddenNav = NO;
    [self.navigationController pushViewController:courseVC animated:YES];
}
- (void)reloadMemoryList{
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
    [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _memoryArray = json[@"data"];
            [_tableView reloadData];
            _subLabel.text = [NSString stringWithFormat:@"一次订阅所有记忆法课程，仅需%zd学习豆!",[self getTotalPrice]];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud showWithMessage:@"数据请求失败"];
    }];
}
#pragma mark 轮播图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 9/16.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
    }else{
        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
    }
    self.cycleScrollView.imageURLStringsGroup = self.netImages;
    self.cycleScrollView.autoScrollTimeInterval = 3.0f;
    return _cycleScrollView;
}
#pragma mark 订阅所有记忆法
- (IBAction)subscribe:(id)sender {
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:@"如果确定，将一次订阅所有记忆法课程"];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (NSInteger)getTotalPrice{
    NSInteger totalPrice = 0;
    for (NSDictionary *item in _memoryArray) {
        if ([item[@"coursePayStatus"] integerValue] == 0) {
            totalPrice = totalPrice + [item[@"coursePrice"] integerValue];
        }
    }
    return totalPrice;
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //学习豆不足
        if ([self getTotalPrice]>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
            [YHHud showWithMessage:@"您的学习豆不足，请充值"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isHiddenNav = YES;
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
                payVC.isHiddenNav = YES;
                [self.navigationController pushViewController:payVC animated:YES];
            });
        }else{
            //学习豆充足
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"type":@"memory",@"device_id":DEVICEID};
            [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
                if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                    [self returnToLogin];
                }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                    _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-113);
                    _buttomBgView.alpha = 0;
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:_memoryArray];
                    for (NSInteger i = 0; i<arr.count; i++) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:i]];
                        [dic setObject:[NSNumber numberWithInt:1] forKey:@"coursePayStatus"];
                        [arr replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
                    }
                    _memoryArray = [NSArray arrayWithArray:arr];
                    [_tableView reloadData];
                    [YHHud showWithSuccess:@"订阅成功"];
                    [self updateCostBean];
                }else if([json[@"code"] isEqualToString:@"ERROR"]){
                    [YHHud showWithMessage:@"服务器错误"];
                }else{
                    [YHHud showWithMessage:@"订阅失败"];
                }
            } failure:^(NSError * _Nonnull error) {
                [YHHud showWithMessage:@"数据请求失败"];
            }];
        }
    }
    [_alertView dismissWithCompletion:nil];
}
#pragma mark 更新用户的消费学习豆
- (void)updateCostBean{
    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            [YHSingleton shareSingleton].userInfo.costStudyBean = [NSString stringWithFormat:@"%@",json[@"data"][@"consumeBean"]];
            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud showWithMessage:@"数据请求失败"];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHiddenNav == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
@end
