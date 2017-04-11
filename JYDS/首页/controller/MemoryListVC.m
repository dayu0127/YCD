//
//  MemoryListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/11.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryListVC.h"
#import "MemoryMoreCell.h"

@interface MemoryListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *memoryVideoList;
@end

@implementation MemoryListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryMoreCell" bundle:nil] forCellReuseIdentifier:@"MemoryMoreCell"];
//    {
//        "userPhone":"*****",        #用户手机号
//        "token":"*****",            #登陆凭证
//        "pageIndex":1               #记忆法页数
//    }
    NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,    //    #用户手机号
                                          @"token":self.token,         //   #登陆凭证
                                          @"pageIndex":@"1"};       //        #记忆法页数
    [YHWebRequest YHWebRequestForPOST:kMemoryVideo parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            _memoryVideoList = [NSDictionary dictionaryWithJsonString:json[@"data"]][@"indexMemory"];
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
    return _memoryVideoList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH*182/375.0+39;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemoryMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoryMoreCell" forIndexPath:indexPath];
    [cell addModelWithDic:_memoryVideoList[indexPath.row]];
    return cell;
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
