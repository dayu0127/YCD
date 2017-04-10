//
//  WordSubedList.m
//  JYDS
//
//  Created by liyu on 2017/4/10.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordSubedList.h"
#import "SubedCell.h"
#import "Word.h"
#import "WordDetailVC.h"
@interface WordSubedList ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *subedWordList;
@property (strong,nonatomic) Word *word;
@end

@implementation WordSubedList


- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"SubedCell" bundle:nil] forCellReuseIdentifier:@"SubedCell"];
    //    {
    //        "userPhone":"******"    #用户手机号
    //        "token":"****"          #登陆凭证
    //        "unitId"："****"         #单元id
    //        "classId"："****"        #课本id
    //        "pageIndex":1           #当前页数
    //    }
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                              @"unitId" :_unitId,    // #单元ID
                              @"pageIndex":@"1",         //  #当前页数
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWordSubedList parameters:jsonDic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _subedWordList = resultDic[@"subWordList"];
            [_tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        NSLog(@"%@",error);
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _subedWordList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
    [cell addModelWithDic:_subedWordList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _word = [Word yy_modelWithJSON:_subedWordList[indexPath.row]];
    [self performSegueWithIdentifier:@"toWordSubedDetail" sender:self];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WordDetailVC *wordDetailVC = segue.destinationViewController;
    wordDetailVC.word = _word;
}


@end
