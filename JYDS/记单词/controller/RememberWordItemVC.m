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
@property (weak, nonatomic) IBOutlet UIView *footerBgView;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *wordID;
@property (copy,nonatomic) NSString *wordPrice;
@property (strong,nonatomic) NSArray <NSIndexPath *> *indexPathArray;
@property (assign,nonatomic) NSInteger allWordPrice;
@property (assign,nonatomic) NSInteger buyStyle;//0--单个订阅 1--全部订阅

@end
@implementation RememberWordItemVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:self.navTitle];
    self.leftBarButton.hidden = NO;
    [self nightModeConfiguration];
    [self initTableView];
    [self initWordTable];
}
- (void)nightModeConfiguration{
    _footerBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _subscriptionLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
#pragma mark 初始化TableView
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-108) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
- (void)initWordTable{
    _allWordPrice = 0;
    CGFloat h = 0;
    NSInteger count = 0;
    NSInteger subCount = 0;
    for (NSDictionary *dic in _wordArray) {
        NSArray *wordArray = dic[@"wordData"];
        count+=wordArray.count;
        for (NSDictionary *item in wordArray) {
            if ([item[@"payType"] integerValue] == 0) {
                _allWordPrice += [item[@"wordPrice"] integerValue];
            }else{
                subCount++;
            }
        }
    }
    if (count == subCount) {
        h =  HEIGHT-64;
        _footerBgView.alpha = 0;
    }else{
        h = HEIGHT-108;
        _footerBgView.alpha = 1;
    }
    _tableView.frame = CGRectMake(0, 64, WIDTH, h);
    [_tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
    [_tableView reloadData];
    self.subscriptionLabel.text = [NSString stringWithFormat:@"一次订阅所有%@的视频教程,仅需%zd学习豆!",self.navTitle,_allWordPrice];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.wordArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.wordArray[section][@"wordData"];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    titleLabel.text = _wordArray[section][@"Title"];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RememberWordSingleWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordSingleWordCell" forIndexPath:indexPath];
    [cell addModelWithDic:self.wordArray[indexPath.section][@"wordData"][indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.wordArray[indexPath.section][@"wordData"][indexPath.row][@"payType"] intValue] == 0) {
        _buyStyle = 0;
        //单个单词订阅
        _wordID = self.wordArray[indexPath.section][@"wordData"][indexPath.row][@"wordID"];
        _wordPrice = self.wordArray[indexPath.section][@"wordData"][indexPath.row][@"wordPrice"];
        _indexPathArray = @[indexPath];
        YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 100) title:@"确定购买？" message:nil];
        alertView.delegate = self;
        _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
        [_alertView show];
    }else{
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:self.wordArray[indexPath.section][@"wordData"][indexPath.row]];
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}

#pragma mark 全部订阅
- (IBAction)subscriptionClick:(id)sender {
    NSString *message = @"如果确定，将一次订阅当前所有单词";
    _buyStyle = 1;
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:message];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
        if (_buyStyle == 0) {
            //用户学习豆不够，跳转到充值页面
            NSInteger studyBean = [[YHSingleton shareSingleton].userInfo.studyBean integerValue];
            if (studyBean < [_wordPrice integerValue]) {
                [YHHud showWithMessage:@"您的学习豆不足，请充值"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
                    payVC.isHiddenNav = YES;
                    [self.navigationController pushViewController:payVC animated:YES];
                });
            }else{
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"productID":_wordID,@"type":@"word",@"money":_wordPrice};
                [YHWebRequest YHWebRequestForPOST:SUB parameters:dic success:^(NSDictionary *json) {
                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                        for (NSInteger i = 0; i<_wordArray.count; i++) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:@"wordData"]];
                            for (NSInteger j = 0; j<arr.count; j++) {
                                NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:j]];
                                if ([item[@"wordID"] integerValue] == [_wordID integerValue]) {
                                    [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
                                }
                                [arr replaceObjectAtIndex:j withObject:[NSDictionary dictionaryWithDictionary:item]];
                            }
                            [dic setObject:arr forKey:@"wordData"];
                            [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
                        }
                        //刷新当前cell的数据
                        [_tableView reloadRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                        //刷新显示的总价
                        self.subscriptionLabel.text = [NSString stringWithFormat:@"一次订阅所有%@的视频教程,仅需%zd学习豆!",self.navTitle,[self getTotalPrice]];
                        [YHHud showWithSuccess:@"订阅成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBean" object:nil];
                    }else if([json[@"code"] isEqualToString:@"ERROR"]){
                        [YHHud showWithMessage:@"服务器错误"];
                    }else{
                        [YHHud showWithMessage:@"订阅失败"];
                    }
                }];
            }
        }else{
            //学习豆不足
            if (_allWordPrice>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
                [self pushPayVC];
            }else{
                //学习豆充足
                _allWordPrice = [self getTotalPrice];
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"payStudyBean":[NSString stringWithFormat:@"%zd",_allWordPrice],@"type":@"words",@"classifyID":_classifyID};
                [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                        _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
                        _footerBgView.alpha = 0;
                        for (NSInteger i = 0; i<_wordArray.count; i++) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:@"wordData"]];
                            for (NSInteger j = 0; j<arr.count; j++) {
                                NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:j]];
                                [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
                                [arr replaceObjectAtIndex:j withObject:[NSDictionary dictionaryWithDictionary:item]];
                            }
                            [dic setObject:arr forKey:@"wordData"];
                            [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
                        }
                        //全部数据刷新
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
    }
}
#pragma mark 获取所有未订阅单词的总价
- (NSInteger)getTotalPrice{
    NSInteger totalPrice = 0;
    for (NSDictionary *dic in _wordArray) {
        NSArray *wordArray = dic[@"wordData"];
        for (NSDictionary *item in wordArray) {
            if ([item[@"payType"] integerValue] == 0) {
                totalPrice += [item[@"wordPrice"] integerValue];
            }
        }
    }
    return totalPrice;
}
- (void)pushPayVC{
    [YHHud showWithMessage:@"您的学习豆不足，请充值"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
        payVC.isHiddenNav = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    });
}
@end
