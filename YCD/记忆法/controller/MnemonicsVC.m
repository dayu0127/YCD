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
@interface MnemonicsVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate>
@property (strong,nonatomic)NSArray *netImages;  //网络图片
@property (strong,nonatomic)SDCycleScrollView *cycleScrollView;//轮播器
@property (weak, nonatomic) IBOutlet UIView *scrollBgView;
@property (strong, nonatomic) BaseTableView *tableView;
@property (strong,nonatomic) JCAlertView *alertView;
@property (strong,nonatomic) NSArray *courseUrlArray;
@end

@implementation MnemonicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self scrollNetWorkImages];
    [self initTableView];
}
#pragma mark 懒加载网络图片数据
-(NSArray *)netImages{
    if (!_netImages) {
        _netImages = @[
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/72f082025aafa40f507b2e99aa64034f78f01930.jpg",
                       @"http://b.hiphotos.baidu.com/zhidao/pic/item/4b90f603738da9770889666fb151f8198718e3d4.jpg",
                       @"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee4e84ef5d2cf5e0fe98257ed4.jpg",
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/9922`720e0cf3d7ca104edf32f31fbe096b63a93e.jpg"
                       ];
    }
    return _netImages;
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
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 9/16.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner01"]];
    self.cycleScrollView.currentPageDotColor = [UIColor darkGrayColor];
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];
    self.cycleScrollView.imageURLStringsGroup = self.netImages;
    self.cycleScrollView.autoScrollTimeInterval = 3.0f;
    [self.scrollBgView addSubview:self.cycleScrollView];
}
#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    NSLog(@"%ld",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
}
- (void)initTableView{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64+9/16.0*WIDTH, WIDTH, HEIGHT-108-9/16.0*WIDTH) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setRefreshData:^{
//        NSLog(@"下拉刷新数据");
    }];
    [_tableView setLoadMoreData:^{
//        NSLog(@"上拉加载更多");
    }];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
}
#pragma tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MnemonicsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MnemonicsCell" forIndexPath:indexPath];
    return cell;
}
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
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:@"如果确定，将一次订阅所有记忆法课程"];
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
@end
