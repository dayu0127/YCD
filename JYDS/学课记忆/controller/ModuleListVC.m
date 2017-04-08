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
#import "SubAlertView.h"
@interface ModuleListVC ()<UITableViewDelegate,UITableViewDataSource,SubAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *moduleList;
@property (copy,nonatomic) NSString *unitId;
@property (strong,nonatomic) UIView *opaqueView;
@end

@implementation ModuleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    [_tableView registerNib:[UINib nibWithNibName:@"ModuleCell" bundle:nil] forCellReuseIdentifier:@"ModuleCell"];
//    {
//        "classId":"******"      #课本ID
//        "userPhone":"***"       #用户手机号
//        "token":"****"          #登陆凭证
//    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary *jsonDic = @{
            @"classId":_classId,    // #课本ID
            @"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,     //  #用户手机号
            @"token":token         // #登陆凭证
        };
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
    [self performSegueWithIdentifier:@"toWordList" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWordList"]) {
        WordListVC *wordListVC = segue.destinationViewController;
        wordListVC.classId = _classId;
        wordListVC.unitId = _unitId;
    }
}
- (IBAction)subAllWordBtnClick:(UIButton *)sender {
    _opaqueView = [[UIView alloc] initWithFrame:self.view.frame];
    _opaqueView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [[UIApplication sharedApplication].keyWindow addSubview:_opaqueView];
    SubAlertView *alertView = [[SubAlertView alloc] init];
    alertView.delegate = self;
    alertView.backgroundColor = [UIColor whiteColor];
    [_opaqueView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_opaqueView).offset(27);
        make.right.equalTo(_opaqueView).offset(-27);
        make.top.equalTo(_opaqueView).offset(221/667*HEIGHT);
        make.height.mas_equalTo(@((WIDTH-54)*7/8.0));
    }];
}
#pragma mark 继续订阅
- (void)continueSubClick{
    NSLog(@"继续订阅");
}
#pragma mark 邀请好友
- (void)invitateFriendClick{
    NSLog(@"邀请好友");
}
#pragma mark 关闭提示框
- (void)closeClick{
    [_opaqueView removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
