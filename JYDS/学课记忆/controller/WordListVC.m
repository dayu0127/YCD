//
//  WordListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordListVC.h"
#import "NotSubCell.h"
#import "SubedCell.h"
#import "WordDetailVC.h"
#import "Word.h"
#import "SureSubView.h"
#import "PayViewController.h"
#import "UILabel+Utils.h"
@interface WordListVC ()<UITableViewDelegate,UITableViewDataSource,SureSubViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *notSubBtn;
@property (weak, nonatomic) IBOutlet UIButton *subedBtn;
@property (weak, nonatomic) IBOutlet UIView *underLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftSpace;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) UITableView *noSubTableView;
@property (strong, nonatomic) UITableView *subedTableView;
@property (assign,nonatomic) int tableIndex;
@property (strong, nonatomic) UIButton *subAllButton;
@property (strong,nonatomic) NSMutableArray *noSubWordList;
@property (strong,nonatomic) NSMutableArray *subedWordList;
@property (strong,nonatomic) Word *word;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *inviteCount;
@property (copy,nonatomic) NSString *preferentialPrice;
@property (copy,nonatomic) NSString *payPrice;
@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageIndex1;
@property (strong,nonatomic) UILabel *noSubLabel;
@end

@implementation WordListVC
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWordSubStatus) name:@"updateWordSubStatus" object:nil];
    
    //scrollView 设置
    _mainScrollView.contentSize = CGSizeMake(WIDTH*2, 0);
    CGFloat tableHeight = HEIGHT-108;
    //未订阅列表
    _noSubTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, tableHeight) style:UITableViewStylePlain];
    _noSubTableView.delegate = self;
    _noSubTableView.dataSource = self;
    _noSubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noSubTableView.showsVerticalScrollIndicator = NO;
    [_mainScrollView addSubview:_noSubTableView];
    [_noSubTableView registerNib:[UINib nibWithNibName:@"NotSubCell" bundle:nil] forCellReuseIdentifier:@"NotSubCell"];
//    [self getNoSubData];
    _pageIndex = 1;
    [self loadNoSubDataWithRefreshStatus:UITableViewRefreshStatusAnimation pageIndex:_pageIndex];
    self.noSubTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self loadNoSubDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
    }];
    self.noSubTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self loadNoSubDataWithRefreshStatus:UITableViewRefreshStatusFooter pageIndex:_pageIndex];
    }];
    //已订阅列表
//    _subedTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-108) style:UITableViewStylePlain];
//    _subedTableView.delegate = self;
//    _subedTableView.dataSource = self;
//    _subedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _subedTableView.showsVerticalScrollIndicator = NO;
//    [_mainScrollView addSubview:_subedTableView];
//    [_subedTableView registerClass:[SubedCell class] forCellReuseIdentifier:@"SubedCell"];
    [self loadSubedTableView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getNoSubData{
//    //    {
//    //        "classId":"******"      #版本ID
//    //        "unitId" :"*******"     #单元ID
//    //        "pageIndex":1           #当前页数
//    //        "userPhone":"***"       #用户手机号
//    //        "token":"****"          #登陆凭证
//    //    }
//    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
//                              @"unitId" :_unitId,    // #单元ID
//                              @"pageIndex":@"1",         //  #当前页数
//                              @"userPhone":self.phoneNum,     //  #用户手机号
//                              @"token":self.token};       //   #登陆凭证
//    [YHWebRequest YHWebRequestForPOST:kWordList parameters:jsonDic success:^(NSDictionary *json) {
//        if([json[@"code"] integerValue] == 200){
//            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
//            _noSubWordList = [NSMutableArray arrayWithArray:resultDic[@"unitWordList"]];
//            _tableIndex = 0;
//            [_noSubTableView reloadData];
//        }else{
//            NSLog(@"%@",json[@"code"]);
//            [YHHud showWithMessage:json[@"message"]];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
}
- (void)loadNoSubDataWithRefreshStatus:(UITableViewRefreshStatus)status pageIndex:(NSInteger)pageIndex{
    if (status==UITableViewRefreshStatusAnimation) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{
        @"classId":_classId,    //  #版本ID
        @"unitId" :_unitId,    // #单元ID
        @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex],         //  #当前页数
        @"userPhone":self.phoneNum,     //  #用户手机号
        @"token":self.token       //   #登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kWordList parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"unitWordList"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
                _noSubWordList = [NSMutableArray arrayWithArray:resultArray];
                _tableIndex = 0;
                [self.noSubTableView reloadData];
                if (status==UITableViewRefreshStatusHeader) {
                    [self.noSubTableView.mj_header endRefreshing];
                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
                    [self.noSubTableView.mj_footer resetNoMoreData];
                }
            }else if (status == UITableViewRefreshStatusFooter){
                [self.noSubTableView.mj_header endRefreshing];
                [_noSubWordList addObjectsFromArray:resultArray];
                [self.noSubTableView reloadData];
                [self.noSubTableView.mj_footer endRefreshing];
            }
        }else if([json[@"code"] integerValue] == 106){
            [self.noSubTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
            if (status==UITableViewRefreshStatusHeader) {
                [self.noSubTableView.mj_header endRefreshing];
            }else if (status==UITableViewRefreshStatusFooter){
                [self.noSubTableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (status==UITableViewRefreshStatusHeader) {
            [self.noSubTableView.mj_header endRefreshing];
        }else if (status==UITableViewRefreshStatusFooter){
            [self.noSubTableView.mj_footer endRefreshing];
        }else if (status==UITableViewRefreshStatusAnimation){
            [YHHud dismiss];
        }
    }];
}
- (void)getSubedData{
    if (_subedWordList!=nil) {
        _tableIndex = 1;
        [_subedTableView reloadData];
    }else{
        [self loadSubedData];
    }
}
- (void)loadSubedDataWithRefreshStatus:(UITableViewRefreshStatus)status pageIndex:(NSInteger)pageIndex{
    if (status==UITableViewRefreshStatusAnimation) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{
        @"classId":_classId,    //  #版本ID
        @"unitId" :_unitId,    // #单元ID
        @"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex],         //  #当前页数
        @"userPhone":self.phoneNum,     //  #用户手机号
        @"token":self.token       //   #登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kWordSubedList parameters:jsonDic success:^(NSDictionary *json) {
        if (status==UITableViewRefreshStatusAnimation) {
            [YHHud dismiss];
        }
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *resultArray =  resultDic[@"subWordList"];
            if (status == UITableViewRefreshStatusAnimation || status == UITableViewRefreshStatusHeader) {
//                if (resultArray.count>0) {
//                    if (_subedTableView == nil) {
//                        [self loadSubedTableView];
//                    }
//                }
                if (_noSubLabel!=nil) {
                    [_noSubLabel removeFromSuperview];
                    _noSubLabel = nil;
                }
                _subedTableView.alpha = 1;
                _subedWordList = [NSMutableArray arrayWithArray:resultArray];
                _tableIndex = 1;
                [self.subedTableView reloadData];
                if (status==UITableViewRefreshStatusHeader) {
                    [self.subedTableView.mj_header endRefreshing];
                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
                    [self.subedTableView.mj_footer resetNoMoreData];
                }
            }else if (status == UITableViewRefreshStatusFooter){
                [_subedWordList addObjectsFromArray:resultArray];
                [self.subedTableView reloadData];
                [self.subedTableView.mj_footer endRefreshing];
            }
        }else if([json[@"code"] integerValue] == 106){
            if (_subedWordList.count == 0) {
                [self loadNoSubView];
            }else{
                [self.subedTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
            if (status==UITableViewRefreshStatusHeader) {
                [self.subedTableView.mj_header endRefreshing];
            }else if (status==UITableViewRefreshStatusFooter){
                [self.subedTableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (status==UITableViewRefreshStatusHeader) {
            [self.subedTableView.mj_header endRefreshing];
        }else if (status==UITableViewRefreshStatusFooter){
            [self.subedTableView.mj_footer endRefreshing];
        }else if (status==UITableViewRefreshStatusAnimation){
            [YHHud dismiss];
        }
    }];
}
- (void)loadNoSubView{
    _noSubLabel = [UILabel new];
    _noSubLabel.text = @"您还未订阅单词，快去订阅吧！";
    _noSubLabel.textAlignment = NSTextAlignmentCenter;
    _noSubLabel.textColor = LIGHTGRAYCOLOR;
    _noSubLabel.font = [UIFont systemFontOfSize:16.0f];
    [_mainScrollView addSubview:_noSubLabel];
    [_noSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScrollView).offset(WIDTH);
        make.centerY.equalTo(_mainScrollView);
        make.right.equalTo(_mainScrollView);
        make.width.mas_equalTo(@(WIDTH));
    }];
}
- (void)loadSubedTableView{
    _subedTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-108) style:UITableViewStylePlain];
    _subedTableView.delegate = self;
    _subedTableView.dataSource = self;
    _subedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subedTableView.showsVerticalScrollIndicator = NO;
    [_mainScrollView addSubview:_subedTableView];
    [_subedTableView registerClass:[SubedCell class] forCellReuseIdentifier:@"SubedCell"];
    _subedTableView.alpha = 0;
}
- (void)loadSubedData{
    _pageIndex1 = 1;
    [self loadSubedDataWithRefreshStatus:UITableViewRefreshStatusAnimation pageIndex:_pageIndex1];
    self.subedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex1 = 1;
        [self loadSubedDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex1];
    }];
    self.subedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex1++;
        [self loadSubedDataWithRefreshStatus:UITableViewRefreshStatusFooter pageIndex:_pageIndex1];
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_mainScrollView.contentOffset.x == WIDTH) {
        [self rightSet];
    }else{
        [self leftSet];
    }
}

#pragma mark 未订阅单词按钮点击
- (IBAction)notSubBtnClick:(UIButton *)sender {
    [self leftSet];
}
#pragma mark 已订阅单词按钮点击
- (IBAction)subedBtnClick:(UIButton *)sender {
    [self rightSet];
}
- (void)leftSet{
    [_notSubBtn setTitleColor:ORANGERED forState:UIControlStateNormal];
    [_subedBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    _lineLeftSpace.constant = 0;
    [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    if ([_payType isEqualToString:@"0"]) {
//        _subAllButton.alpha = 1;
//    }
//    if (_subedTableView.alpha == ) {
//        <#statements#>
//    }
    _tableIndex = 0;
    [self.noSubTableView reloadData];
//    [self.noSubTableView.mj_header beginRefreshing];
//    _pageIndex = 1;
//    [self loadNoSubDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex];
//    NSDictionary *jsonDic = @{
//        @"classId":_classId,    //  #版本ID
//        @"unitId" :_unitId,    // #单元ID
//        @"pageIndex":@"1",         //  #当前页数
//        @"userPhone":self.phoneNum,     //  #用户手机号
//        @"token":self.token       //   #登陆凭证
//    };
//    [YHWebRequest YHWebRequestForPOST:kWordList parameters:jsonDic success:^(NSDictionary *json) {
//        if([json[@"code"] integerValue] == 200){
//            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
//            NSArray *resultArray =  resultDic[@"unitWordList"];
//                _noSubWordList = [NSMutableArray arrayWithArray:resultArray];
//                _tableIndex = 0;
//                [self.noSubTableView reloadData];
//                if (status==UITableViewRefreshStatusHeader) {
//                    [self.noSubTableView.mj_header endRefreshing];
//                    // 重置没有更多的数据（消除没有更多数据的状态）！！！！！！
//                    [self.noSubTableView.mj_footer resetNoMoreData];
//                }
//            }else if (status == UITableViewRefreshStatusFooter){
//                [_noSubWordList addObjectsFromArray:resultArray];
//                [self.noSubTableView reloadData];
//                [self.noSubTableView.mj_footer endRefreshing];
//            }
//        }else if([json[@"code"] integerValue] == 106){
//            [self.noSubTableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            NSLog(@"%@",json[@"code"]);
//            [YHHud showWithMessage:json[@"message"]];
//            if (status==UITableViewRefreshStatusHeader) {
//                [self.noSubTableView.mj_header endRefreshing];
//            }else if (status==UITableViewRefreshStatusFooter){
//                [self.noSubTableView.mj_footer endRefreshing];
//            }
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        if (status==UITableViewRefreshStatusHeader) {
//            [self.noSubTableView.mj_header endRefreshing];
//        }else if (status==UITableViewRefreshStatusFooter){
//            [self.noSubTableView.mj_footer endRefreshing];
//        }else if (status==UITableViewRefreshStatusAnimation){
//            [YHHud dismiss];
//        }
//    }];
}
- (void)rightSet{
    [_subedBtn setTitleColor:ORANGERED forState:UIControlStateNormal];
    [_notSubBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    _lineLeftSpace.constant = WIDTH/2.0;
    [_mainScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
//    _subAllButton.alpha = 0;
//    _pageIndex1 = 1;
//    [self loadNoSubDataWithRefreshStatus:UITableViewRefreshStatusHeader pageIndex:_pageIndex1];
    [self getSubedData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableIndex == 0) {
        return _noSubWordList.count;
    }else{
        return _subedWordList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableIndex == 0) {
        NotSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotSubCell" forIndexPath:indexPath];
        [cell addModelWithDic:_noSubWordList[indexPath.row]];
        cell.subBtn.tag = indexPath.row;
        [cell.subBtn addTarget:self action:@selector(freeSubClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
        [cell addModelWithDic:_subedWordList[indexPath.row]];
        return cell;
    }
}
#pragma mark 订阅按钮
- (void)freeSubClick:(UIButton *)sender{
    [self freeSub:sender.tag];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableIndex == 0) {//单个单词免费查阅
        [self freeSub:indexPath.row];
    }else{
        _word = [Word yy_modelWithJSON:_subedWordList[indexPath.row]];
        [self performSegueWithIdentifier:@"toWordDetail" sender:self];
    }
}
- (void)freeSub:(NSInteger)wordRowIndex{
    _word = [Word yy_modelWithJSON:_noSubWordList[wordRowIndex]];
    //单个单词订阅
    NSString *freeCount = [YHSingleton shareSingleton].userInfo.freeCount;
    if ([freeCount integerValue] == 0) {
        [YHHud showWithMessage:@"免费次数已用完，请前去订阅本学期所有单词"];
    }else{
        SureSubView *sureSubView = [[SureSubView alloc] initWithNib];
        sureSubView.messageLabel.text = [NSString stringWithFormat:@"您还有%@次免费订阅的额度",freeCount];
        sureSubView.delegate = self;
        _alertView = [[JCAlertView alloc] initWithCustomView:sureSubView dismissWhenTouchedBackground:NO];
        [_alertView show];
    }
}
- (void)cancelClick{
    [_alertView dismissWithCompletion:nil];
}
#pragma makr 确认订阅
- (void)sureClick{
    [_alertView dismissWithCompletion:nil];
    //        {
    //            "classId":"******"      #课本ID
    //            "wordId" :"*******"     #单词ID
    //            "userPhone":"***"       #用户手机号
    //            "token":"****"          #登陆凭证
    //        }
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #课本ID
                              @"wordId" :_word.wordId,  //   #单词ID
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};        //  #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kFreeWord parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            //刷新本地用户订阅次数
            [YHSingleton shareSingleton].userInfo.freeCount = [NSString stringWithFormat:@"%@",resultDic[@"freeCount"]];
            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
            //刷新未订阅列表
            for (NSInteger i = 0; i<_noSubWordList.count; i++) {
                NSDictionary *itemDic = _noSubWordList[i];
                if ([itemDic[@"wordId"] isEqualToString:_word.wordId]) {
                    [_noSubWordList removeObjectAtIndex:i];
                    break;
                }
            }
            [_subedBtn setTitleColor:ORANGERED forState:UIControlStateNormal];
            [_notSubBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
            _lineLeftSpace.constant = WIDTH/2.0;
            [_mainScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
            //刷新已订阅列表
            [self reloadSubedTableView];
            [YHHud showWithSuccess:@"订阅成功"];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)reloadSubedTableView{
    _tableIndex = 1;
    if (_subedWordList.count!=0) {
        [_subedWordList addObject:[_word yy_modelToJSONObject]];
        [_subedTableView reloadData];
    }else{
        [self loadSubedData];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordDetail"]) {
        WordDetailVC *wordDetail = segue.destinationViewController;
        wordDetail.word = _word;
        wordDetail.showCollectButton = NO;
    }
}
@end
