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
/**年级列表*/
@property (strong,nonatomic) NSArray *gradeList;
/**学期列表*/
@property (strong,nonatomic) NSArray *semesterList;
/**版本列表*/
@property (strong,nonatomic) NSArray *versionNameList;
/**年级名称列表*/
@property (strong,nonatomic) NSArray *gradeNameList;
/**学期名称列表*/
@property (strong,nonatomic) NSArray *semesterNameTypeList;
/**版本名称列表*/
@property (strong,nonatomic) NSArray *versionNameNameList;
/**课本列表*/
@property (strong,nonatomic) NSMutableArray *versionList;
@property (assign,nonatomic) NSInteger selectIndex;
/**当前年级ID*/
@property (strong,nonatomic) NSString *currentGradeID;
/**当前学期ID*/
@property (strong,nonatomic) NSString *currentSemesterID;
///**当前科目ID*/
//@property (strong,nonatomic) NSString *currentClassID;
/**当前版本ID*/
@property (strong,nonatomic) NSString *currentVersionNameID;
/**选中课本ID*/
@property (strong,nonatomic) NSString *classId;
/**选中课本订阅状态*/
@property (strong,nonatomic) NSString *payType;
/**选中课本年级名称*/
@property (strong,nonatomic) NSString *gradeName;
/**选中课本全价*/
@property (copy,nonatomic) NSString *full_price;
/**选中课本最低价*/
@property (copy,nonatomic) NSString *preferentialPrice;
@property (strong,nonatomic) TopMenuView *menuView1;
@property (strong,nonatomic) TopMenuView *menuView2;
@property (strong,nonatomic) TopMenuView *menuView3;
@end
@implementation GradeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWordSubStatus) name:@"updateWordSubStatus" object:nil];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    CGFloat c = (WIDTH-2)/3.0;
    NSArray *arr = @[@"年级",@"学期",@"版本"];
    NSMutableArray *menuArray = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i< 3; i++) {
        TopMenuView *topV = [[TopMenuView alloc] initWithFrame:CGRectMake(i*(c+1), 0, c, 44) title:arr[i] tag:i];
        topV.delegate = self;
        [_topMenuBgView addSubview:topV];
        [menuArray addObject:topV];
        if (i<2) {
            UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(c*(i+1), 15.5, 1, 13)];
            v_line.backgroundColor = LIGHTGRAYCOLOR;
            [_topMenuBgView addSubview:v_line];
        }
    }
    _menuView1 = (TopMenuView *)menuArray[0];
    _menuView2 = (TopMenuView *)menuArray[1];
    _menuView3 = (TopMenuView *)menuArray[2];
    //获取数据
    [self getGredeList];
    [_tableView registerNib:[UINib nibWithNibName:@"GradeCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
}
- (void)updateWordSubStatus{
    NSDictionary *jsonDic = @{
        @"grade_type":_grade_type,        //#查询状态 1：小学 2：初中 3：高中
        @"userPhone":self.phoneNum,     //  #用户手机号
        @"token":self.token             // #登陆凭证
    };
    [YHWebRequest YHWebRequestForPOST:kWordIndex parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _versionList = [NSMutableArray arrayWithArray:resultDic[@"versionList"]];   //课本
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 获取年级列表
- (void)getGredeList{
    //    {
    //        "grade_type":"1"        #查询状态 1：小学 2：初中 3：高中
    //        "userPhone":"***"       #用户手机号
    //        "token":"****"          #登陆凭证
    //    }
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{
                              @"grade_type":_grade_type,        //#查询状态 1：小学 2：初中 3：高中
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token       // #登陆凭证
                              };
    [YHWebRequest YHWebRequestForPOST:kWordIndex parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _gradeList = resultDic[@"gradeList"];   //年级
            _semesterList = resultDic[@"getSemesterList"];   //学期
            _versionNameList = resultDic[@"versionNameList"];   //版本
            if (_classTypeIndex==nil) {
                _versionList = [NSMutableArray arrayWithArray:resultDic[@"versionList"]];   //课本
                [_tableView reloadData];
                [YHHud dismiss];
            }else{
                NSInteger index = [_classTypeIndex integerValue];
                [_menuView3 updateWidth:_versionNameList[index][@"class_name"]];
                _currentVersionNameID = _versionNameList[index][@"class_type"];
                [self getGredeListFromDic];
            }
        }else{
            [YHHud dismiss];
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        NSLog(@"%@",error);
    }];
}
#pragma mark 根据条件获取课本列表
- (void)getGredeListFromDic{
    NSDictionary *jsonDic = [self getJsonDic];
    [YHWebRequest YHWebRequestForPOST:kWodeBook parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _versionList = resultDic[@"versionList"];   //课本
            [_tableView reloadData];
            [YHHud dismiss];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
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
        [YBPopupMenu showRelyOnView:sender titles:[self getNameListFromArray:_gradeList keyName:@"grade_name"] icons:nil menuWidth:WIDTH/3.0-10 delegate:self];
    }else if(sender.tag == 1){  //学期选择
        [YBPopupMenu showRelyOnView:sender titles:[self getNameListFromArray:_semesterList keyName:@"semesterName"]  icons:nil menuWidth:WIDTH/3.0-10 delegate:self];
    }else{  //版本选择
        [YBPopupMenu showRelyOnView:sender titles:[self getNameListFromArray:_versionNameList keyName:@"class_name"]  icons:nil menuWidth:WIDTH/3.0-10 delegate:self];
    }
}
- (NSDictionary *)getJsonDic{
    NSMutableDictionary *baseDic = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"gradeType":_grade_type,    //       #年段代码（选填：和gradeId填选一个）
        @"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,   //    #用户手机号
        @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],      //    #登陆凭证
        @"selectType":@"0"      //     #查询类型 0:根据上面条件查询，1：已订阅
    }];
    if (_currentGradeID!=nil) {
        [baseDic setObject:_currentGradeID forKey:@"gradeId"];
    }
    if (_currentSemesterID!=nil) {
        [baseDic setObject:_currentSemesterID forKey:@"semesterId"];
    }
    if (_currentVersionNameID!=nil) {
        [baseDic setObject:_currentVersionNameID forKey:@"version"];
    }
    return [NSDictionary dictionaryWithDictionary:baseDic];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (_selectIndex == 0) {//根据年级查询
        if (index == 0) {
            _currentGradeID = nil;
            [_menuView1 updateWidth:@"全部年级"];
            [_menuView2 updateWidth:@"学期"];
            [_menuView3 updateWidth:@"版本"];
            [self getGredeList];
        }else{
            _currentGradeID = _gradeList[index-1][@"gradeId"];
            [_menuView1 updateWidth:_gradeList[index-1][@"grade_name"]];
            [self getGredeListFromDic];
        }
    }else if(_selectIndex == 1){//根据学期查询
        _currentSemesterID = _semesterList[index][@"semesterId"];
        [_menuView2 updateWidth:_semesterList[index][@"semesterName"]];
        [self getGredeListFromDic];
    }else{
        _currentVersionNameID = _versionNameList[index][@"class_type"];
        [_menuView3 updateWidth:_versionNameList[index][@"class_name"]];
        [self getGredeListFromDic];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _versionList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (WIDTH-20)*(30/71.0)*(49/75.0)+72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addModelWithDic:_versionList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _classId  = _versionList[indexPath.row][@"classId"];
    _full_price = _versionList[indexPath.row][@"full_price"];
    _preferentialPrice = _versionList[indexPath.row][@"preferentialPrice"];
    _payType  = [NSString stringWithFormat:@"%@",_versionList[indexPath.row][@"payType"]];
    _gradeName = _versionList[indexPath.row][@"grade_name"];
    [self performSegueWithIdentifier:@"toModuleList" sender:self];
}
- (NSArray *)getNameListFromArray:(NSArray *)arr keyName:(NSString *)str{
    NSMutableArray *array = [NSMutableArray array];
    if ([str isEqualToString:@"grade_name"]) {
        [array addObject:@"全部年级"];
    }
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
        moduleListVC.full_price = _full_price;
        moduleListVC.preferentialPrice = _preferentialPrice;
    }
}
@end
