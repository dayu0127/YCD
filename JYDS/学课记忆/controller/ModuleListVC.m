//
//  ModuleListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ModuleListVC.h"
#import "ModuleCell.h"
#import "WordListVC.h"
#import "WordSubedList.h"
#import "SubAlertView.h"
#import "PayViewController.h"
#import "UILabel+Utils.h"
@interface ModuleListVC ()<UITableViewDelegate,UITableViewDataSource,SubAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *moduleList;
@property (copy,nonatomic) NSString *unitId;
@property (strong,nonatomic) JCAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *subAllButton;
@end

@implementation ModuleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWordSubStatus) name:@"updateWordSubStatus" object:nil];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    [_tableView registerNib:[UINib nibWithNibName:@"ModuleCell" bundle:nil] forCellReuseIdentifier:@"ModuleCell"];
    if ([_payType isEqualToString:@"0"]) {
        _subAllButton.alpha = 1;
    }else{
        _subAllButton.alpha = 0;
    }
//    {
//        "classId":"******"      #课本ID
//        "userPhone":"***"       #用户手机号
//        "token":"****"          #登陆凭证
//    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary *jsonDic = @{@"classId":_classId,    // #课本ID
                                          @"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,     //  #用户手机号
                                          @"token":token};         // #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kModuleList parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _moduleList = resultDic[@"unitList"];
            [_tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)updateWordSubStatus{
    _subAllButton.alpha = 0;
    _payType = @"1";
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _moduleList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCell" forIndexPath:indexPath];
    [cell addModelWithDic:_moduleList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _unitId = _moduleList[indexPath.row][@"unitId"];
    if ([_payType isEqualToString:@"0"]) {
        [self performSegueWithIdentifier:@"toWordList" sender:self];
    }else{
        [self performSegueWithIdentifier:@"toWordSubedList" sender:self];
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordList"]) {
        WordListVC *wordListVC = segue.destinationViewController;
        wordListVC.classId = _classId;
        wordListVC.unitId = _unitId;
        wordListVC.payType = _payType;
        wordListVC.gradeName = _gradeName;
    }else if([segue.identifier isEqualToString:@"toWordSubedList"]){
        WordSubedList *wordSubedList = segue.destinationViewController;
        wordSubedList.classId = _classId;
        wordSubedList.unitId = _unitId;
    }else if ([segue.identifier isEqualToString:@"toPayViewController"]){
        PayViewController *payVC = segue.destinationViewController;
        payVC.classId = _classId;
        payVC.payType = @"0";    //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
        [YHSingleton shareSingleton].payType = @"0";
    }
}
- (IBAction)subAllWordBtnClick:(UIButton *)sender {
    SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
    NSString *str = [NSString stringWithFormat:@"一次性订阅%@所有单词仅需100元!",_gradeName];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ORANGERED,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] range:NSMakeRange(str.length-5, 3)];
    subAlertView.label_0.attributedText = attStr;
    subAlertView.label_1.text = [NSString stringWithFormat:@"最多可邀请5个好友，订阅%@所有单词价格低至100元。",_gradeName];
    [subAlertView.label_1 setText:subAlertView.label_1.text lineSpacing:7.0f];
    subAlertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:subAlertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
#pragma mark 继续订阅
- (void)continueSubClick{
    [_alertView dismissWithCompletion:^{
        [self performSegueWithIdentifier:@"toPayViewController" sender:self];
    }];
}
#pragma mark 邀请好友
- (void)invitateFriendClick{
    [_alertView dismissWithCompletion:^{
        [self performSegueWithIdentifier:@"moduleListToInviteRewards" sender:self];
    }];
}
#pragma mark 关闭提示框
- (void)closeClick{
    [_alertView dismissWithCompletion:nil];
}
@end
