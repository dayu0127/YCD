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
#import "PayVC.h"

@interface RememberWordItemVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *wordID;
@property (copy,nonatomic) NSString *wordPrice;
@property (strong,nonatomic) NSArray <NSIndexPath *> *indexPathArray;
@property (assign,nonatomic) NSInteger allWordPrice;
@property (assign,nonatomic) NSInteger buyStyle;//0--单个订阅 1--全部订阅
@property (assign,nonatomic) BOOL isHiddenNav;
@property (nonatomic,strong) NSMutableArray *wordArray;

@end
@implementation RememberWordItemVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:self.navTitle];
    self.leftBarButton.hidden = NO;
    [self createWordTable];
}
- (void)createWordTable{
    [YHHud showWithStatus:@"单词加载中..."];
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID,@"device_id":DEVICEID,@"unitID":_unitID};
    [YHWebRequest YHWebRequestForPOST:WORD parameters:dic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _wordArray = [NSMutableArray arrayWithArray:json[@"data"]];
            [self initTableView];
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
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
    [self.view addSubview:_tableView];
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
        _wordID = self.wordArray[indexPath.row][@"wordID"];
//        _wordPrice = self.wordArray[indexPath.row][@"wordPrice"];
        _indexPathArray = @[indexPath];
        NSDictionary *usrDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        UserInfo *userInfo = [UserInfo yy_modelWithDictionary:usrDic];
        YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 155) title:@"确认订阅"  message:[NSString stringWithFormat:@"免费单词订阅次数为:%@",userInfo.freeCount]];
        alertView.delegate = self;
        _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
        [_alertView show];
    }else{
        _isHiddenNav = NO;
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:self.wordArray[indexPath.row]];
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
        //用户免费订阅次数不够
        NSDictionary *usrDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        UserInfo *userInfo = [UserInfo yy_modelWithDictionary:usrDic];
        if ([userInfo.freeCount integerValue] == 0) {
            [YHHud showWithMessage:@"您的单词免费订阅次数为0，请前往订阅"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"wordID":_wordID,@"device_id":DEVICEID};
            [YHWebRequest YHWebRequestForPOST:FREEWORD parameters:dic success:^(NSDictionary *json) {
                if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                    [self returnToLogin];
                }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                    [YHSingleton shareSingleton].userInfo.freeCount = [NSString stringWithFormat:@"%@",json[@"freeCount"]];
                    [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                    for (NSInteger i = 0; i<_wordArray.count; i++) {
//                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
//                        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:@"wordData"]];
//                        for (NSInteger j = 0; j<arr.count; j++) {
//                            NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:j]];
//                            if ([item[@"wordID"] integerValue] == [_wordID integerValue]) {
//                                [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
//                            }
//                            [arr replaceObjectAtIndex:j withObject:[NSDictionary dictionaryWithDictionary:item]];
//                        }
//                        [dic setObject:arr forKey:@"wordData"];
//                        [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
                        NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
                        if ([item[@"wordID"] integerValue] == [_wordID integerValue]) {
                            [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
                        }
                        [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:item]];
                    }
                    //刷新当前cell的数据
                    [_tableView reloadRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    [YHHud showWithSuccess:@"订阅成功"];
//                    [_delegate updateSubBean];
//                    [self updateCostBean];
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
}
//#pragma mark 更新用户的消费学习豆
//- (void)updateCostBean{
//    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
//        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//            [YHSingleton shareSingleton].userInfo.costStudyBean = [NSString stringWithFormat:@"%@",json[@"data"][@"consumeBean"]];
//            [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
//        }else if([json[@"code"] isEqualToString:@"ERROR"]){
//            [YHHud showWithMessage:@"服务器错误"];
//        }else{
//            [YHHud showWithMessage:@"数据异常"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [YHHud showWithMessage:@"数据请求失败"];
//    }];
//}
- (void)pushPayVC{
    [YHHud showWithMessage:@"您的学习豆不足，请充值"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isHiddenNav = YES;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
        payVC.isHiddenNav = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHiddenNav == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
@end
