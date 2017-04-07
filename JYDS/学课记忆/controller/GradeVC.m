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
@end
@implementation GradeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [YHSingleton shareSingleton].userInfo = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    CGFloat c = (WIDTH-2)/3.0;
    NSArray *arr = @[@"年级",@"科目",@"版本"];
    for (int i = 0; i< 3; i++) {
        TopMenuView *topV = [[TopMenuView alloc] initWithFrame:CGRectMake(i*(c+1), 0, c, 44) title:arr[i] tag:i];
        topV.delegate = self;
        [_topMenuBgView addSubview:topV];
        if (i<2) {
            UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(c*(i+1), 18, 1, 13)];
            v_line.backgroundColor = GRAYCOLOR;
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
            NSLog(@"%@",_versionList);
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
    NSLog(@"%@",_versionList[indexPath.row]);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toModuleList" sender:self];
}
- (NSArray *)getNameListFromArray:(NSArray *)arr keyName:(NSString *)str{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *itemDic in arr) {
        [array addObject:itemDic[str]];
    }
    return [NSArray arrayWithArray:array];
}
@end
