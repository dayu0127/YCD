//
//  MyCollectVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MyCollectVC.h"
#import "CollectHeadCell.h"
#import "CollectCell.h"
@interface MyCollectVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *myCollectList;
@end

@implementation MyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCollectList:1];
    [_tableView registerNib:[UINib nibWithNibName:@"CollectHeadCell" bundle:nil] forCellReuseIdentifier:@"CollectHeadCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"CollectCell"];
}
- (void)loadCollectList:(NSInteger)index{
//    {
//        "userPhone":"******"    #用户手机号
//        "token":"****"          #登陆凭证
//        "pageIndex":1           #页数
//    }
    if (index == 1) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,    //    #用户手机号
                              @"token":self.token,         //   #登陆凭证
                              @"pageIndex":@"1"};       //        #页数
    [YHWebRequest YHWebRequestForPOST:kCollectionList parameters:jsonDic success:^(NSDictionary *json) {
        if (index == 1) {
            [YHHud dismiss];
        }
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _myCollectList = [NSMutableArray arrayWithArray:jsonData[@"collectionList"]];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        if (index == 1) {
            [YHHud dismiss];
        }
        NSLog(@"%@",error);
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myCollectList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 56;
    }else{
        return 50;
    }
}
#pragma mark 删除行
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.tableView) {
            NSString *classId = _myCollectList[indexPath.row][@"class_id"];
            NSString *unitId = _myCollectList[indexPath.row][@"unit_id"];
            NSString *wordId = _myCollectList[indexPath.row][@"wordId"];
            //        {
            //            "userPhone":"******"    #用户手机号
            //            "token":"****"          #登陆凭证
            //            "unitId"："****"         #单元id
            //            "classId"："****"        #课本id
            //            "wordId":"**"           #单词id
            //        }
            NSDictionary *jsonDic = @{@"classId":classId,    //  #版本ID
                                      @"unitId" :unitId,    // #单元ID
                                      @"wordId":wordId,         //  #当前页数
                                      @"userPhone":self.phoneNum,     //  #用户手机号
                                      @"token":self.token};       //   #登陆凭证
            [YHWebRequest YHWebRequestForPOST:kCancelCollectionWord parameters:jsonDic success:^(NSDictionary *json) {
                if([json[@"code"] integerValue] == 200){
                    [_myCollectList removeObjectAtIndex:indexPath.row];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    [YHHud showWithMessage:@"删除成功"];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    NSLog(@"%@",json[@"message"]);
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CollectHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectHeadCell" forIndexPath:indexPath];
        return cell;
    }else{
        CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell" forIndexPath:indexPath];
        [cell addModelWithDic:_myCollectList[indexPath.row]];
        return cell;
    }
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
