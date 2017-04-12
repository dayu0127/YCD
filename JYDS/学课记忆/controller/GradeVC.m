//
//  GradeVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "GradeVC.h"
#import "TopMenuView.h"
#import "GradeCell.h"
#import "YBPopupMenu.h"
#import "ModuleListVC.h"
@interface GradeVC ()<TopMenuViewDelegate,UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *topMenuBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *gradeList;
@property (strong,nonatomic) NSArray *classTypeList;
@property (strong,nonatomic) NSArray *versionNameList;
@property (strong,nonatomic) NSArray *gradeNameList;
@property (strong,nonatomic) NSArray *classNameTypeList;
@property (strong,nonatomic) NSArray *versionNameNameList;
@property (strong,nonatomic) NSArray *versionList;
@property (assign,nonatomic) NSInteger selectIndex;
/**当前年级ID*/
@property (strong,nonatomic) NSString *currentGradeID;
/**当前科目ID*/
@property (strong,nonatomic) NSString *currentClassID;
/**当前版本ID*/
@property (strong,nonatomic) NSString *currentVersionNameID;
/**选中课本ID*/
@property (strong,nonatomic) NSString *classId;
/**选中课本订阅状态*/
@property (strong,nonatomic) NSString *payType;
/**选中课本年级名称*/
@property (strong,nonatomic) NSString *gradeName;
@end
@implementation GradeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGredeList) name:@"updateWordSubStatus" object:nil];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    CGFloat c = (WIDTH-2)/3.0;
    NSArray *arr = @[@"年级",@"科目",@"版本"];
    for (int i = 0; i< 3; i++) {
        TopMenuView *topV = [[TopMenuView alloc] initWithFrame:CGRectMake(i*(c+1), 0, c, 44) title:arr[i] tag:i];
        topV.delegate = self;
        [_topMenuBgView addSubview:topV];
        if (i<2) {
            UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(c*(i+1), 18, 1, 13)];
            v_line.backgroundColor = LIGHTGRAYCOLOR;
            [_topMenuBgView addSubview:v_line];
        }
    }
    //获取数据
    [self getGredeList];
    [_tableView registerNib:[UINib nibWithNibName:@"GradeCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
}
#pragma mark 获取年级列表
- (void)getGredeList{
//    {
//        "grade_type":"1"        #查询状态 1：小学 2：初中 3：高中
//        "userPhone":"***"       #用户手机号
//        "token":"****"          #登陆凭证
//    }
    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary *jsonDic = @{@"grade_type":@"1",        //#查询状态 1：小学 2：初中 3：高中
                                          @"userPhone":phoneNum,     //  #用户手机号
                                          @"token":token};       // #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kGradeList parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _gradeList = resultDic[@"gradeList"];   //年级
            _classTypeList = resultDic[@"classTypeList"];   //科目
            _versionNameList = resultDic[@"versionNameList"];   //版本
            _versionList = resultDic[@"versionList"];   //课本
            [_tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)menuClick:(UIButton *)sender{
    _selectIndex = sender.tag;
    if (sender.tag == 0) { //年级选择
        YBPopupMenu *menu = [YBPopupMenu showRelyOnView:sender titles:[self getNameListFromArray:_gradeList keyName:@"grade_name"] icons:nil menuWidth:WIDTH/3.0-20 delegate:self];
        menu.fontSize = 9.0f;
    }else if(sender.tag == 1){  //科目选择
        YBPopupMenu *menu = [YBPopupMenu showRelyOnView:sender titles:[self getNameListFromArray:_classTypeList keyName:@"class_name"]  icons:nil menuWidth:WIDTH/3.0-20 delegate:self];
        menu.fontSize = 13.0f;
    }else{  //版本选择
        YBPopupMenu *menu = [YBPopupMenu showRelyOnView:sender titles:[self getNameListFromArray:_versionNameList keyName:@"class_name"]  icons:nil menuWidth:WIDTH/3.0-20 delegate:self];
        menu.fontSize = 11.0f;
    }
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (_selectIndex == 0) { //根据年级ID查科目列表和课本列表
//        {
//            "gradeId":"******"      #年级ID
//            "userPhone":"***"       #用户手机号
//            "token":"****"          #登陆凭证
//        }
        _currentGradeID = _gradeList[index][@"gradeId"];
        NSDictionary *jsonDic = @{@"gradeId":_currentGradeID,        //#年级ID
                                  @"userPhone":phoneNum,     //  #用户手机号
                                  @"token":token};       // #登陆凭证
        [YHWebRequest YHWebRequestForPOST:kClassTypeList parameters:jsonDic success:^(NSDictionary *json) {
            if([json[@"code"] integerValue] == 200){
                NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _classTypeList = resultDic[@"classTypeList"];   //科目
                _versionList = resultDic[@"versionList"];   //课本
                [_tableView reloadData];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else if (_selectIndex  == 1){ //根据科目ID查版本列表和课本列表
//        {
//            "gradeId":"******"      #年级ID
//            "classType":"1"         #科目代码
//            "userPhone":"***"       #用户手机号
//            "token":"****"          #登陆凭证
//        }
        _currentClassID = _classTypeList[index][@"class_type"];
        NSDictionary *jsonDic = @{@"gradeId":_currentGradeID,        //#年级ID
                                  @"classType":_currentClassID,  // #科目代码
                                  @"userPhone":phoneNum,     //  #用户手机号
                                  @"token":token};       // #登陆凭证
        [YHWebRequest YHWebRequestForPOST:kClassTypeList parameters:jsonDic success:^(NSDictionary *json) {
            if([json[@"code"] integerValue] == 200){
                NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _versionNameList = resultDic[@"versionNameList"];   //版本
//                NSLog(@"%@",_versionNameList);
                _versionList = resultDic[@"versionList"];   //课本
                [_tableView reloadData];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{ //根据课本ID查课本列表
//        {
//            "gradeType":1           #年段代码（选填：和gradeId填选一个）
//            "gradeId":"******"      #年级ID（选填：和gradeType填选一个）
//            "classType":"1"         #科目代码（选填）
//            "version":"1"           #版本代码（选填）
//            "userPhone":"***"       #用户手机号
//            "token":"****"          #登陆凭证
//        }
        _currentVersionNameID = _versionNameList[index][@"class_type"];
        NSDictionary *jsonDic = @{
            @"gradeType":_grade_type,          // #年段代码（选填：和gradeId填选一个）
            @"gradeId":_currentGradeID,    //  #年级ID（选填：和gradeType填选一个）
            @"classType":_currentClassID,     //    #科目代码（选填）
            @"version":_currentVersionNameID,        //   #版本代码（选填）
            @"userPhone":phoneNum,     //  #用户手机号
            @"token":token      //   #登陆凭证
            };
        [YHWebRequest YHWebRequestForPOST:kVersionNameList parameters:jsonDic success:^(NSDictionary *json) {
            if([json[@"code"] integerValue] == 200){
                NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _versionList = resultDic[@"versionList"];   //课本
                [_tableView reloadData];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _versionList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (WIDTH-20)*(30/71.0)*(49/75.0)+72;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addModelWithDic:_versionList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _classId  = _versionList[indexPath.row][@"classId"];
    _payType  = [NSString stringWithFormat:@"%@",_versionList[indexPath.row][@"payType"]];
    _gradeName = _versionList[indexPath.row][@"grade_name"];
    [self performSegueWithIdentifier:@"toModuleList" sender:self];
}
- (NSArray *)getNameListFromArray:(NSArray *)arr keyName:(NSString *)str{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *itemDic in arr) {
        [array addObject:itemDic[str]];
    }
    return [NSArray arrayWithArray:array];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toModuleList"]) {
        ModuleListVC *moduleListVC = segue.destinationViewController;
        moduleListVC.classId =_classId;
        moduleListVC.payType =_payType;
        moduleListVC.gradeName = _gradeName;
    }
}
@end
