//
//  MyCourseSubedVC.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MyCourseSubedVC.h"
#import "GradeCell.h"
#import "ModuleListVC.h"
@interface MyCourseSubedVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *courseSubedList;
/**选中课本ID*/
@property (strong,nonatomic) NSString *classId;
@end

@implementation MyCourseSubedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCourseList];
    [_tableView registerNib:[UINib nibWithNibName:@"GradeCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 获取已订阅课本列表
- (void)getCourseList{
//    {
//        "userPhone":"***"       #用户手机号
//        "token":"****"          #登陆凭证
//        "selectType":           #查询类型 0:根据上面条件查询，1：已订阅
//        "pageIndex":            #查询页数（选填，select为1时候需要）
//    }
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{@"pageIndex":@"1",        // #查询页数（选填，select为1时候需要）
                              @"selectType":@"1",    //       #查询类型 0:根据上面条件查询，1：已订阅
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};       // #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kVersionList parameters:jsonDic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _courseSubedList = resultDic[@"versionList"];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        NSLog(@"%@",error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _courseSubedList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (WIDTH-20)*(30/71.0)*(49/75.0)+72;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addModelWithDic:_courseSubedList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _classId  = _courseSubedList[indexPath.row][@"classId"];
    [self performSegueWithIdentifier:@"MySubToModuleList" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MySubToModuleList"]) {
        ModuleListVC *moduleListVC = segue.destinationViewController;
        moduleListVC.classId =_classId;
        moduleListVC.payType = @"1";
    }
}


@end
