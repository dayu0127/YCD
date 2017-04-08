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
@interface WordListVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *notSubBtn;
@property (weak, nonatomic) IBOutlet UIButton *subedBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomSpace;
@property (assign,nonatomic) int tableIndex;
@property (weak, nonatomic) IBOutlet UIButton *subAllButton;
@property (strong,nonatomic) NSMutableArray *noSubWordList;
@property (strong,nonatomic) NSMutableArray *subedWordList;
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
    _noSubWordList = [NSMutableArray array];
    _subedWordList = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"NotSubCell" bundle:nil] forCellReuseIdentifier:@"NotSubCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SubedCell" bundle:nil] forCellReuseIdentifier:@"SubedCell"];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
//    {
//        "classId":"******"      #版本ID
//        "unitId" :"*******"     #单元ID
//        "pageIndex":1           #当前页数
//        "userPhone":"***"       #用户手机号
//        "token":"****"          #登陆凭证
//    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                                        @"unitId" :_unitId,    // #单元ID
                                        @"pageIndex":@"1",         //  #当前页数
                                        @"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,     //  #用户手机号
                                        @"token":token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWordList parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            NSArray *wordList = resultDic[@"unitWordList"];
            for (NSDictionary *wordDic in wordList) {
                if ([wordDic[@"payType"] integerValue] == 0) {
                    [_noSubWordList addObject:wordDic];
                }else{
                    [_subedWordList addObject:wordDic];
                }
            }
            [_tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)notSubBtnClick:(UIButton *)sender {
    _tableIndex = 0;
    [_tableView reloadData];
    _subAllButton.alpha = 1;
    _tableViewBottomSpace.constant = 65;
}
- (IBAction)subedBtnClick:(UIButton *)sender {
    _tableIndex = 1;
    [_tableView reloadData];
    _subAllButton.alpha = 0;
    _tableViewBottomSpace.constant = 0;
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
#pragma mark 免费查阅
- (void)subBtnClick:(UIButton *)sender{
    //获取用户剩余查询次数
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _word = [Word yy_modelWithJSON:_noSubWordList[indexPath.row]];
    if (_tableIndex == 0) {//单个单词免费查阅
        //单个单词订阅
        NSString *freeCount = [YHSingleton shareSingleton].userInfo.freeCount;
        if ([freeCount integerValue] == 0) {
            [YHHud showWithMessage:@"免费次数已用完，请前去订阅本学期所有单词"];
        }else{
            YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 155) title:@"确认订阅"  message:[NSString stringWithFormat:@"您还有%@次免费订阅的额度，确定使用吗？",freeCount]];
            alertView.delegate = self;
            _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
            [_alertView show];
        }
    }else{
        [self performSegueWithIdentifier:@"toWordDetail" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordDetail"]) {
        WordDetailVC *wordDetail = segue.destinationViewController;
        wordDetail.word = _word;
    }
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
//        {
//            "classId":"******"      #课本ID
//            "wordId" :"*******"     #单词ID
//            "userPhone":"***"       #用户手机号
//            "token":"****"          #登陆凭证
//        }
        NSDictionary *jsonDic = @{@"classId":_classId,    //  #课本ID
                                            @"wordId" :_word.wordId,  //   #单词ID
                                            @"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,     //  #用户手机号
                                            @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};        //  #登陆凭证
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
                [_subedWordList addObject:[_word yy_modelToJSONObject]];
                [_tableView reloadData];
                [YHHud showWithSuccess:@"订阅成功"];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        //        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"wordID":_wordID,@"device_id":DEVICEID};
        //        [YHWebRequest YHWebRequestForPOST:FREEWORD parameters:dic success:^(NSDictionary *json) {
        //            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
        //                [self returnToLogin];
        //            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
        //                [YHSingleton shareSingleton].userInfo.freeCount = [NSString stringWithFormat:@"%@",json[@"freeCount"]];
        //                [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
        //                for (NSInteger i = 0; i<_wordArray.count; i++) {
        //                    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
        //                    if ([item[@"wordID"] integerValue] == [_wordID integerValue]) {
        //                        [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
        //                    }
        //                    [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:item]];
        //                }
        //                //刷新当前cell的数据
        //                [_tableView reloadRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        //                [YHHud showWithSuccess:@"订阅成功"];
        //                [_delegate updateSubBean];
        //            }else if([json[@"code"] isEqualToString:@"ERROR"]){
        //                [YHHud showWithMessage:@"服务器错误"];
        //            }else{
        //                [YHHud showWithMessage:@"订阅失败"];
        //            }
        //        } failure:^(NSError * _Nonnull error) {
        //            [YHHud showWithMessage:@"数据请求失败"];
        //        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
@end
