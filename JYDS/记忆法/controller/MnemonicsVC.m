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
#import "PayVC.h"

@interface MnemonicsVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate,MemoryCourseVCDelegate>
@property (strong,nonatomic) NSMutableArray *netImages;  //网络图片
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;//轮播器
//@property (strong, nonatomic) BaseTableView *tableView;
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
    _buttomBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
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
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID};
    [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _memoryArray = json[@"data"];
            //显示总价
            NSInteger totalPrice = 0;
            for (NSDictionary *dic in _memoryArray) {
                if ([dic[@"coursePayStatus"] integerValue] == 0) {
                    totalPrice = totalPrice + [dic[@"coursePrice"] integerValue];
                }
            }
            _subLabel.text = [NSString stringWithFormat:@"一次订阅所有记忆法课程，仅需%zd学习豆!",totalPrice];
//            _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-157) style:UITableViewStyleGrouped];
            //计算tableView的高度
            CGFloat h = 0;
            NSInteger count = 0;
            for (NSDictionary *dic in _memoryArray) {
                if ([dic[@"coursePayStatus"] integerValue] == 1) {
                    count++;
                }
            }
            if (count == _memoryArray.count) {
                h = HEIGHT-113;
                _buttomBgView.alpha = 0;
            }else{
                h = HEIGHT-157;
            }
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, h) style:UITableViewStyleGrouped];
            _tableView.delegate = self;
            _tableView.dataSource =  self;
            _tableView.rowHeight = 100;
            _tableView.separatorInset = UIEdgeInsetsZero;
            _tableView.backgroundColor = [UIColor clearColor];
//            [_tableView setRefreshData:^{
//                //        NSLog(@"下拉刷新数据");
//            }];
//            [_tableView setLoadMoreData:^{
//                //        NSLog(@"上拉加载更多");
//            }];
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
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID};
    [YHWebRequest YHWebRequestForPOST:MEMORY parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _memoryArray = json[@"data"];
            [_tableView reloadData];
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
#pragma mark 订阅所有课程
- (IBAction)subscribe:(id)sender {
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:@"如果确定，将一次订阅所有记忆法课程"];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger totalPrice = 0;
        for (NSDictionary *dic in _memoryArray) {
            Mnemonics *model = [Mnemonics yy_modelWithJSON:dic];
            if ([model.coursePayStatus isEqualToString:@"0"]) {
                totalPrice = totalPrice + [model.coursePrice integerValue];
            }
        }
        //学习豆不足
        if (totalPrice>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
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
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"payStudyBean":[NSString stringWithFormat:@"%zd",totalPrice],@"type":@"memory"};
            [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
                if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBean" object:nil];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHiddenNav == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
@end
