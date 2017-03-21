//
//  RememberWordItemVC.m
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordItemVC.h"
#import "RememberWordSingleWordCell.h"
#import "RememberWordSingleWordDetailVC.h"
#import "Words.h"

@interface RememberWordItemVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *wordID;
@property (strong,nonatomic) NSArray <NSIndexPath *> *indexPathArray;
//@property (assign,nonatomic) BOOL isHiddenNav;
@property (nonatomic,strong) NSMutableArray *wordArray;
@property (strong,nonatomic) MJRefreshNormalHeader *header;
@property (strong,nonatomic) NSMutableArray *wordIDArray;

@end
@implementation RememberWordItemVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
}
- (void)dayMode{
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}
- (void)nightMode{
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:self.navTitle];
    self.leftBarButton.hidden = NO;
    [self createWordTable];
}
- (void)createWordTable{
    [self initTableView];
    [YHHud showWithStatus:@"单词加载中..."];
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID,@"device_id":DEVICEID,@"unitID":_unitID};
    [YHWebRequest YHWebRequestForPOST:WORD parameters:dic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            self.wordArray = [NSMutableArray arrayWithArray:json[@"data"]];
            [self.tableView reloadData];
            // 获取所有单词的ID数组
            _wordIDArray = [NSMutableArray array];
            for (NSInteger i = 0; i < self.wordArray.count; i++) {
                [_wordIDArray addObject:self.wordArray[i][@"wordID"]];
            }
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        [YHHud showWithMessage:@"数据请求失败"];
    }];
}
#pragma mark 初始化TableView
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID,@"device_id":DEVICEID,@"unitID":_unitID};
        [YHWebRequest YHWebRequestForPOST:WORD parameters:dic success:^(NSDictionary *json) {
            [_tableView.mj_header endRefreshing];
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                self.wordArray = [NSMutableArray arrayWithArray:json[@"data"]];
                [self.tableView reloadData];
                // 获取所有单词的ID数组
                _wordIDArray = [NSMutableArray array];
                for (NSInteger i = 0; i < self.wordArray.count; i++) {
                    [_wordIDArray addObject:self.wordArray[i][@"wordID"]];
                }
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"数据异常"];
            }
        } failure:^(NSError * _Nonnull error) {
            [_tableView.mj_header endRefreshing];
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
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _wordArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RememberWordSingleWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordSingleWordCell" forIndexPath:indexPath];
    [cell addModelWithDic:self.wordArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.wordArray[indexPath.row][@"payType"] intValue] == 0) {
        //单个单词订阅
        NSDictionary *usrDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        UserInfo *userInfo = [UserInfo yy_modelWithDictionary:usrDic];
        if ([userInfo.freeCount integerValue] == 0) {
            [YHHud showWithMessage:@"免费次数已用完，请前去订阅本学期所有单词"];
        }else{
            _wordID = self.wordArray[indexPath.row][@"wordID"];
            _indexPathArray = @[indexPath];
            YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 155) title:@"确认订阅"  message:[NSString stringWithFormat:@"您还有%@次免费订阅的额度，确定使用吗？",userInfo.freeCount]];
            alertView.delegate = self;
            _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
            [_alertView show];
        }
    }else{
//        _isHiddenNav = NO;
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:self.wordArray[indexPath.row]];
        wordDetailVC.wordIDArray = [NSArray arrayWithArray:_wordIDArray];
        wordDetailVC.wordIndex = indexPath.row;
        wordDetailVC.isSub = _isSub;
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"wordID":_wordID,@"device_id":DEVICEID};
        [YHWebRequest YHWebRequestForPOST:FREEWORD parameters:dic success:^(NSDictionary *json) {
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                [YHSingleton shareSingleton].userInfo.freeCount = [NSString stringWithFormat:@"%@",json[@"freeCount"]];
                [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                for (NSInteger i = 0; i<_wordArray.count; i++) {
                    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
                    if ([item[@"wordID"] integerValue] == [_wordID integerValue]) {
                        [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
                    }
                    [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:item]];
                }
                //刷新当前cell的数据
                [_tableView reloadRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                [YHHud showWithSuccess:@"订阅成功"];
                [_delegate updateSubBean];
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
@end
