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
#import "BaseTableView.h"
#import "BannerDetailVC.h"
#import "Mnemonics.h"
#import <UIImageView+WebCache.h>
@interface MnemonicsVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong,nonatomic) NSDictionary *userInfo;
@property (strong,nonatomic) NSMutableArray *netImages;  //网络图片
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;//轮播器
@property (strong, nonatomic) BaseTableView *tableView;
@property (strong,nonatomic) JCAlertView *alertView;
@property (strong,nonatomic) NSArray *bannerInfoArray;
@property (strong,nonatomic) NSArray *memoryArray;
@end

@implementation MnemonicsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    _netImages = [NSMutableArray array];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
    for (NSDictionary *dic in _bannerInfoArray) {
        [_netImages addObject:dic[@"topImageUrl"]];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
}
- (void)initNavBar{
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    navBar.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"记忆大师"];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(WIDTH * 0.5, 42);
    [navBar addSubview:titleLabel];
    [self.view addSubview:navBar];
}
- (void)dayMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
}
- (void)nightMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
}
#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerDetailVC *bannerVC = [[BannerDetailVC alloc] init];
    bannerVC.title = _bannerInfoArray[index][@"topTitle"];
    bannerVC.linkUrl = _bannerInfoArray[index][@"linkUrl"];
    bannerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerVC animated:YES];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
}
- (void)initTableView{
    NSDictionary *dic = @{@"userID":_userInfo[@"userID"]};
    [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _memoryArray = json[@"data"];
            _tableView = [[BaseTableView alloc] initWithFrame:_bgView.bounds style:UITableViewStyleGrouped];
            _tableView.delegate = self;
            _tableView.dataSource =  self;
            _tableView.rowHeight = 100;
            _tableView.separatorInset = UIEdgeInsetsZero;
            _tableView.backgroundColor = [UIColor clearColor];
            [_tableView setRefreshData:^{
                //        NSLog(@"下拉刷新数据");
            }];
            [_tableView setLoadMoreData:^{
                //        NSLog(@"上拉加载更多");
            }];
            [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
            [_bgView addSubview:_tableView];
        }
    }];
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
    return 44;
}
#pragma tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemoryCourseVC *courseVC = [[MemoryCourseVC alloc] init];
    courseVC.hidesBottomBarWhenPushed = YES;
    courseVC.memoryArray = _memoryArray;
    courseVC.memory = [Mnemonics yy_modelWithJSON:_memoryArray[indexPath.row]];
    [self.navigationController pushViewController:courseVC animated:YES];
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    footerView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH-65, 44)];
    label.text = @"一次订阅所有记忆法课程，仅需2000学习豆!";
    label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.backgroundColor = [UIColor clearColor];
    [footerView addSubview:label];
    UIButton *subscriptionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subscriptionButton.frame = CGRectMake(WIDTH-76, 11, 65, 22);
    [subscriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subscriptionButton setTitle:@"订阅" forState:UIControlStateNormal];
    subscriptionButton.layer.cornerRadius = 3.0f;
    subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    subscriptionButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [subscriptionButton addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:subscriptionButton];
    return footerView;
}
#pragma mark 订阅所有课程
- (void)subscribe{
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:@"如果确定，将一次订阅所有记忆法课程"];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger totalPrice = 0;
        for (Mnemonics *model in _memoryArray) {
            if ([model.coursePayStatus isEqualToString:@"0"]) {
                totalPrice = totalPrice + [model.coursePrice integerValue];
            }
        }
        NSDictionary *dic = @{@"userID":_userInfo[@"userID"],@"payStudyBean":[NSString stringWithFormat:@"%zd",totalPrice],@"type":@"memory"};
        [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
            NSLog(@"%@",json);
            NSLog(@"%@",_userInfo);
        }];
    }
    [_alertView dismissWithCompletion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nightMode" object:nil];
}
@end
