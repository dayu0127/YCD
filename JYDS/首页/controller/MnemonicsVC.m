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

@end

@implementation MnemonicsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:@"记忆大师"];
    [self nightModeConfiguration];
    _netImages = [NSMutableArray array];
    _bannerInfoArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
    for (NSDictionary *dic in _bannerInfoArray) {
        [_netImages addObject:dic[@"topImageUrl"]];
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
}
- (void)nightMode{
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlN"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControl_selectN"];
}
#pragma mark 轮播器代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerDetailVC *bannerVC = [[BannerDetailVC alloc] init];
    bannerVC.navTitle = _bannerInfoArray[index][@"topTitle"];
    bannerVC.linkUrl = _bannerInfoArray[index][@"linkUrl"];
    bannerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerVC animated:YES];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
}
- (void)initTableView{
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
    [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _memoryArray = json[@"data"];
            //显示总价
            NSInteger totalPrice = [self getTotalPrice];
            _subLabel.text = [NSString stringWithFormat:@"一次订阅所有记忆法课程，仅需%zd学习豆!",totalPrice];
            //计算tableView的高度
//            CGFloat h = 0;
            NSInteger count = 0;
            for (NSDictionary *dic in _memoryArray) {
                if ([dic[@"coursePayStatus"] integerValue] == 1) {
                    count++;
                }
            }
//            if (count == _memoryArray.count) {
//                h = HEIGHT-113;
//                _buttomBgView.alpha = 0;
//            }else{
//                h = HEIGHT-157;
//            }
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-113) style:UITableViewStyleGrouped];
            _tableView.delegate = self;
            _tableView.dataSource =  self;
            _tableView.rowHeight = 100;
            _tableView.separatorInset = UIEdgeInsetsZero;
            _tableView.backgroundColor = [UIColor clearColor];
            //下拉刷新
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID};
                [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
                    [self.tableView.mj_header endRefreshing];
                    if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                        [self returnToLogin];
                    }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                        _memoryArray = json[@"data"];
                        [self.tableView reloadData];
                        _subLabel.text = [NSString stringWithFormat:@"一次订阅所有记忆法课程，仅需%zd学习豆!",[self getTotalPrice]];
                    }else if([json[@"code"] isEqualToString:@"ERROR"]){
                        [YHHud showWithMessage:@"服务器错误"];
                    }else{
                        [YHHud showWithMessage:@"数据异常"];
                    }
                }];
            }];
            // 设置自动切换透明度(在导航栏下面自动隐藏)
            header.automaticallyChangeAlpha = YES;
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 马上进入刷新状态
            [header beginRefreshing];
            // 设置header
            self.tableView.mj_header = header;
            [_tableView registerNib:[UINib nibWithNibName:@"MnemonicsCell" bundle:nil] forCellReuseIdentifier:@"MnemonicsCell"];
            [self.view addSubview:_tableView];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
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
            NSInteger totalPrice = [self getTotalPrice];
            _subLabel.text = [NSString stringWithFormat:@"一次订阅所有记忆法课程，仅需%zd学习豆!",totalPrice];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    }];
}
#pragma mark 轮播图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 9/16.0*WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        [self dayMode];
    }else{
        [self nightMode];
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
                }else if([json[@"code"] isEqualToString:@"ERROR"]){
                    [YHHud showWithMessage:@"服务器错误"];
                }else{
                    [YHHud showWithMessage:@"订阅失败"];
                }
            }];
        }
    }
    [_alertView dismissWithCompletion:nil];
}
- (void)returnToLogin{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线提醒" message:@"该账号已在其他设备上登录" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
        [app.window setRootViewController:loginVC];
        [app.window makeKeyWindow];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHiddenNav == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
@end
