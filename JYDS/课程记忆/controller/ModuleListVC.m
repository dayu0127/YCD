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
#import "WordSearchListVC.h"
@interface ModuleListVC ()<UITableViewDelegate,UITableViewDataSource,SubAlertViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *moduleList;
@property (copy,nonatomic) NSString *unitId;
@property (strong,nonatomic) JCAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *subAllButton;
@property (copy,nonatomic) NSString *inviteCount;
@property (copy,nonatomic) NSString *preferentialPrice;
@property (copy,nonatomic) NSString *payPrice;
@property (assign,nonatomic) NSInteger wordNum;
@property (strong,nonatomic) NSArray *wordSearchResultArray;
@property (copy,nonatomic) NSString *searchContent;
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
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 单词搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (REGEX(LETTER_RE, searchBar.text) == NO) {
        [YHHud showWithMessage:@"请输入英文单词"];
    }else{
        if (![searchBar.text isEqualToString:@""]) {
            NSDictionary *jsonDic = @{
                @"userPhone":self.phoneNum,   //     #用户手机号
                @"token":self.token,            //      #用户登陆凭证
                @"selContent":searchBar.text       //      #查询内容
            };
            [YHWebRequest YHWebRequestForPOST:kSelectWord parameters:jsonDic success:^(NSDictionary *json) {
                if ([json[@"code"] integerValue] == 200) {
                    NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                    _wordSearchResultArray = resultDic[@"selWordList"];
                    _searchContent = searchBar.text;
                    [self performSegueWithIdentifier:@"toWordSearchVC" sender:self];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    [YHHud showWithMessage:json[@"message"]];
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
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
        _wordNum = [_moduleList[indexPath.row][@"wrodNum"] integerValue];
        [self performSegueWithIdentifier:@"toWordSubedList" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordSearchVC"]) {
        WordSearchListVC *wordSearchListVC = segue.destinationViewController;
        wordSearchListVC.wordSearchResultArray = _wordSearchResultArray;
        wordSearchListVC.searchContent = _searchContent;
    }else if ([segue.identifier isEqualToString:@"toWordList"]) {
        WordListVC *wordListVC = segue.destinationViewController;
        wordListVC.classId = _classId;
        wordListVC.unitId = _unitId;
        wordListVC.payType = _payType;
        wordListVC.gradeName = _gradeName;
    }else if([segue.identifier isEqualToString:@"toWordSubedList"]){
        WordSubedList *wordSubedList = segue.destinationViewController;
        wordSubedList.classId = _classId;
        wordSubedList.unitId = _unitId;
        wordSubedList.wordNum = _wordNum;
    }else if ([segue.identifier isEqualToString:@"toPayViewController"]){
        PayViewController *payVC = segue.destinationViewController;
        payVC.classId = _classId;
        payVC.payType = @"0";    //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
        payVC.inviteCount = _inviteCount;
        payVC.preferentialPrice = _preferentialPrice;
        payVC.payPrice = _payPrice;
        [YHSingleton shareSingleton].payType = @"0";
    }
}
- (IBAction)subAllWordBtnClick:(UIButton *)sender {
    SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
    NSString *str = [NSString stringWithFormat:@"一次性订阅%@所有单词仅需%@元!",_gradeName,_full_price];
    NSRange priceRange= [str rangeOfString:[NSString stringWithFormat:@"%@",_full_price]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ORANGERED,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] range:NSMakeRange(priceRange.location, priceRange.length)];
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
//        {
//            "userPhone":"******"    #用户手机号
//            "token":"****"          #登陆凭证
//            "objectId":"****"       #目标id
//            "payType":"***"         #支付类型 1：记忆法  0：单词课本
//        }
        [YHHud showWithStatus];
        NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,  //  #用户手机号
                                              @"payType" :@"0",         //   #购买类型 0：K12课程单词购买 1：记忆法课程购买
                                              @"objectId":_classId,       //  #目标id
                                              @"token":self.token};       //   #登陆凭证
        [YHWebRequest YHWebRequestForPOST:kOrderPrice parameters:jsonDic success:^(NSDictionary *json) {
            [YHHud dismiss];
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _inviteCount = [NSString stringWithFormat:@"%@",dataDic[@"inviteNum"]];
                float oldPrice = [dataDic[@"price"] floatValue];
                float newPrice = [dataDic[@"discountPrice"] floatValue];
                _preferentialPrice = [NSString stringWithFormat:@"￥%0.2f",oldPrice-newPrice];
                _payPrice = [NSString stringWithFormat:@"￥%0.2f",newPrice];
                [self performSegueWithIdentifier:@"toPayViewController" sender:self];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud dismiss];
            NSLog(@"%@",error);
        }];
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
