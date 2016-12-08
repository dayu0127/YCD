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
#import <JCAlertView.h>
#import "CustomAlertView.h"
@interface MnemonicsVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate>
@property (strong,nonatomic)NSArray *netImages;  //网络图片
@property (strong,nonatomic)SDCycleScrollView *cycleScrollView;//轮播器
@property (weak, nonatomic) IBOutlet UIView *scrollBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIView *footerView;
@property (strong,nonatomic) JCAlertView *alertView;
@end

@implementation MnemonicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self scrollNetWorkImages];
    [self.tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNightMode) name:@"openNightMode" object:nil];
}
#pragma mark 懒加载网络图片数据
-(NSArray *)netImages{
    if (!_netImages) {
        _netImages = @[
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/72f082025aafa40f507b2e99aa64034f78f01930.jpg",
                       @"http://b.hiphotos.baidu.com/zhidao/pic/item/4b90f603738da9770889666fb151f8198718e3d4.jpg",
                       @"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee4e84ef5d2cf5e0fe98257ed4.jpg",
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/9922720e0cf3d7ca104edf32f31fbe096b63a93e.jpg"
                       ];
    }
    return _netImages;
}
#pragma mark 创建网络轮播器
-(void)scrollNetWorkImages{
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDTH, HEIGHT*0.3) delegate:self placeholderImage:[UIImage imageNamed:@"banner01"]];
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
#pragma tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
    UIButton *subscriptionButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-76, 11, 65, 22)];
    [subscriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subscriptionButton setTitle:@"订阅" forState:UIControlStateNormal];
    subscriptionButton.layer.cornerRadius = 3.0f;
    subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    subscriptionButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [subscriptionButton addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:subscriptionButton];
    _footerView = footerView;
    return _footerView;
}
- (void)openNightMode{
    _tableView.backgroundColor = [UIColor blackColor];
}
#pragma mark 订阅所有课程
- (void)subscribe{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认订阅" message:@"如果确认，将一次订阅所有记忆法课程" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"确定订阅");
//    }];
//    [alert addAction:cancel];
//    [alert addAction:sure];
//    [self presentViewController:alert animated:YES completion:nil];
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"确认订阅" message:@"如果确定，将一次订阅所有记忆法课程"];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:YES];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确认订阅");
    }
    [_alertView dismissWithCompletion:nil];
}
@end
