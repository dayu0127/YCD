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
#import "SubAlertView.h"
@interface WordListVC ()<UITableViewDelegate,UITableViewDataSource,SureSubViewDelegate,SubAlertViewDelegate>
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
@property (strong,nonatomic) NSArray *subedWordList;
@property (strong,nonatomic) Word *word;
@property (strong,nonatomic) JCAlertView *alertView;
@end

@implementation WordListVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubStatus) name:@"updateSubStatus" object:nil];
    
    //scrollView 设置
    _mainScrollView.contentSize = CGSizeMake(WIDTH*2, 0);
    CGFloat tableHeight = HEIGHT-108;
    //未订阅列表
    _noSubTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, tableHeight-65) style:UITableViewStylePlain];
    _noSubTableView.delegate = self;
    _noSubTableView.dataSource = self;
    _noSubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noSubTableView.showsVerticalScrollIndicator = NO;
    [_mainScrollView addSubview:_noSubTableView];
    [_noSubTableView registerNib:[UINib nibWithNibName:@"NotSubCell" bundle:nil] forCellReuseIdentifier:@"NotSubCell"];
    [self getNoSubData];
    //订阅按钮
    _subAllButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_noSubTableView.frame)+10, WIDTH-20, 45)];
    [_subAllButton setTitle:@"点击订阅本书所有单词" forState:UIControlStateNormal];
    [_subAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _subAllButton.backgroundColor = ORANGERED;
    _subAllButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_subAllButton addTarget:self action:@selector(subAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_subAllButton];
    if ([_payType isEqualToString:@"0"]) {
        _subAllButton.alpha = 1;
    }else{
        _subAllButton.alpha = 0;
    }
    //已订阅列表
    _subedTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-108) style:UITableViewStylePlain];
    _subedTableView.delegate = self;
    _subedTableView.dataSource = self;
    _subedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subedTableView.showsVerticalScrollIndicator = NO;
    [_mainScrollView addSubview:_subedTableView];
    [_subedTableView registerNib:[UINib nibWithNibName:@"SubedCell" bundle:nil] forCellReuseIdentifier:@"SubedCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getNoSubData{
    //    {
    //        "classId":"******"      #版本ID
    //        "unitId" :"*******"     #单元ID
    //        "pageIndex":1           #当前页数
    //        "userPhone":"***"       #用户手机号
    //        "token":"****"          #登陆凭证
    //    }
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                              @"unitId" :_unitId,    // #单元ID
                              @"pageIndex":@"1",         //  #当前页数
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWordList parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _noSubWordList = [NSMutableArray arrayWithArray:resultDic[@"unitWordList"]];
            _tableIndex = 0;
            [_noSubTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
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
- (void)loadSubedData{
    //    {
    //        "userPhone":"******"    #用户手机号
    //        "token":"****"          #登陆凭证
    //        "unitId"："****"         #单元id
    //        "classId"："****"        #课本id
    //        "pageIndex":1           #当前页数
    //    }
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                              @"unitId" :_unitId,    // #单元ID
                              @"pageIndex":@"1",         //  #当前页数
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWordSubedList parameters:jsonDic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _subedWordList = resultDic[@"subWordList"];
            _tableIndex = 1;
            [self loadSubedData];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        NSLog(@"%@",error);
    }];
}
#pragma mark 订阅所有单词
- (void)subAllButtonClick{
    SubAlertView *sureSubView = [[SubAlertView alloc] initWithNib];
    sureSubView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:sureSubView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
#pragma mark 继续订阅
- (void)continueSubClick{
    [_alertView dismissWithCompletion:nil];
    [self performSegueWithIdentifier:@"toPayViewController" sender:self];
}
#pragma mark 邀请好友
- (void)invitateFriendClick{
    [_alertView dismissWithCompletion:nil];
    NSLog(@"邀请好友");
}
#pragma mark 关闭提示框
- (void)closeClick{
    [_alertView dismissWithCompletion:nil];
}
- (void)updateSubStatus{
    _subAllButton.alpha = 0;
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
    _tableIndex = 0;
}
- (void)rightSet{
    [_subedBtn setTitleColor:ORANGERED forState:UIControlStateNormal];
    [_notSubBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    _lineLeftSpace.constant = WIDTH/2.0;
    [_mainScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
//    _subAllButton.alpha = 0;
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
        return cell;
    }else{
        SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
        [cell addModelWithDic:_subedWordList[indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_tableIndex == 0) {//单个单词免费查阅
        _word = [Word yy_modelWithJSON:_noSubWordList[indexPath.row]];
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
    }else{
        _word = [Word yy_modelWithJSON:_subedWordList[indexPath.row]];
        [self performSegueWithIdentifier:@"toWordDetail" sender:self];
    }
}
- (void)cancelClick{
    [_alertView dismissWithCompletion:nil];
}
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
                if ([itemDic[@"wordId"] integerValue] == [_word.wordId integerValue]) {
                    [_noSubWordList removeObjectAtIndex:i];
                    break;
                }
            }
            [_subedBtn setTitleColor:ORANGERED forState:UIControlStateNormal];
            [_notSubBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
            _lineLeftSpace.constant = WIDTH/2.0;
            [_mainScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
            [self loadSubedData];
            [YHHud showWithSuccess:@"订阅成功"];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordDetail"]) {
        WordDetailVC *wordDetail = segue.destinationViewController;
        wordDetail.word = _word;
    }
}
#pragma mark 滑动手势处理函数
- (void)swipe:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [_mainScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
    }else{
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
@end
