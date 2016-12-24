//
//  MnemonicsVC.m
//  YCD
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsVC.h"
#import <SDCycleScrollView.h>
#import "MnemonicsCell.h"
#import "MemoryCourseVC.h"
#import "BaseTableView.h"
#import "Singleton.h"
#import "BannerDetailVC.h"
#import "YHTableDelegate.h"
#import "YHDataSource.h"
#import "Mnemonics.h"
#import <UIImageView+WebCache.h>
@interface MnemonicsVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,YHAlertViewDelegate>
@property (strong,nonatomic)NSMutableArray *netImages;  //网络图片
@property (strong,nonatomic)SDCycleScrollView *cycleScrollView;//轮播器
@property (weak, nonatomic) IBOutlet UIView *scrollBgView;
@property (strong, nonatomic) BaseTableView *tableView;
@property (strong,nonatomic) YHTableDelegate *tableDelegate;
@property (strong,nonatomic) YHDataSource *dataSource;
@property (strong,nonatomic) JCAlertView *alertView;
@property (strong,nonatomic) NSArray *courseUrlArray;
@property (strong,nonatomic) NSArray *bannerInfoArray;
@end

@implementation MnemonicsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _netImages = [NSMutableArray array];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
    for (NSDictionary *dic in _bannerInfoArray) {
        [_netImages addObject:dic[@"topImageUrl"]];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self scrollNetWorkImages];
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
}
- (void)dayMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
}
- (void)nightMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
}
#pragma mark 懒加载视频url数据
- (NSArray *)courseUrlArray{
    if (!_courseUrlArray) {
        _courseUrlArray = @[@"http://baobab.wdjcdn.com/14564977406580.mp4",
                                     @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                                     @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                                     @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    }
    return _courseUrlArray;
}
#pragma mark 创建网络轮播器
-(void)scrollNetWorkImages{
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 9/16.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControl"];
        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_select"];
    }else{
        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
    }
    self.cycleScrollView.imageURLStringsGroup = self.netImages;
    self.cycleScrollView.autoScrollTimeInterval = 3.0f;
    [self.scrollBgView addSubview:self.cycleScrollView];
}

#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerDetailVC *bannerVC = [[BannerDetailVC alloc] init];
    bannerVC.bannerTitle = @"标题";
    bannerVC.linkUrl = _bannerInfoArray[index][@"linkUrl"];
    bannerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerVC animated:YES];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
}
- (void)initTableView{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSDictionary *dic = @{@"userID":userInfo[@"userID"]};
    [YHWebRequest YHWebRequestForPOST:COURSE parameters:dic success:^(id  _Nonnull json) {
        NSDictionary *jsonDic = json;
        if ([jsonDic[@"code"] isEqualToString:@"SUCCESS"]) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in jsonDic[@"data"]) {
                [dataArray addObject:[Mnemonics modelWithDIc:dic]];
            }
            _dataSource = [[YHDataSource alloc] initWithIdentifier:@"MnemonicsCell" configureBlock:^(id cell, id model, NSIndexPath *indexPath) {
                MnemonicsCell *m_cell = cell;
                Mnemonics *m_model = model;
                [m_cell.courseImageView sd_setImageWithURL:[NSURL URLWithString:m_model.courseImageUrl] placeholderImage:[UIImage imageNamed:@"videoImage"]];
                m_cell.courseTitle.text = m_model.courseName;
                m_cell.courseDetail.text = m_model.courseTitle;
                NSString *studyDouStr = @"";
                if ([m_model.coursePayStatus isEqualToString:@"0"]) {
                    if ([m_model.coursePrice isEqualToString:@"0"]) {
                        studyDouStr = @"免费";
                    }else{
                        studyDouStr = [NSString stringWithFormat:@"%@学习豆",m_model.coursePrice];
                    }
                }else{
                    studyDouStr = @"已订阅";
                }
                m_cell.studyDouLabel.text = studyDouStr;
            }];
            [_dataSource addModels:dataArray];
            _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64+9/16.0*WIDTH, WIDTH, HEIGHT-108-9/16.0*WIDTH) style:UITableViewStylePlain];
            [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
            _tableView.delegate = self;
            _tableView.dataSource =  _dataSource;
            _tableView.rowHeight = 120;
            _tableView.backgroundColor = [UIColor clearColor];
            [_tableView setRefreshData:^{
                //        NSLog(@"下拉刷新数据");
            }];
            [_tableView setLoadMoreData:^{
                //        NSLog(@"上拉加载更多");
            }];
            [self.view addSubview:_tableView];
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络异常 - T_T%@", error);
    }];
//    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64+9/16.0*WIDTH, WIDTH, HEIGHT-108-9/16.0*WIDTH) style:UITableViewStyleGrouped];
//    _tableView.delegate = self;
//    _tableView.dataSource =self;
//    _tableView.backgroundColor = [UIColor clearColor];
//    [_tableView setRefreshData:^{
////        NSLog(@"下拉刷新数据");
//    }];
//    [_tableView setLoadMoreData:^{
////        NSLog(@"上拉加载更多");
//    }];
//    [self.view addSubview:_tableView];
//    [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
}
#pragma tableView代理方法
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 4;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.001;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MnemonicsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MnemonicsCell" forIndexPath:indexPath];
//    return cell;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MnemonicsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MemoryCourseVC *courseVC = [[MemoryCourseVC alloc] init];
    courseVC.hidesBottomBarWhenPushed = YES;
    courseVC.title = cell.courseTitle.text;
    courseVC.videoURL = [NSURL URLWithString:self.courseUrlArray[indexPath.row]];
    [self.navigationController pushViewController:courseVC animated:YES];
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
        NSLog(@"确认订阅");
    }
    [_alertView dismissWithCompletion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nightMode" object:nil];
}
@end
