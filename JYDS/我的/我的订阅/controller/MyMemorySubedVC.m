//
//  MyMemorySubedVC.m
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MyMemorySubedVC.h"
#import "MemoryMoreCell.h"
#import "Memory.h"
#import "MemoryDetailVC.h"
@interface MyMemorySubedVC ()<UITableViewDelegate,UITableViewDataSource,MemoryDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *memoryVideoList;
@property (strong,nonatomic) Memory *memory;
@end

@implementation MyMemorySubedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMemoryList:1];
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryMoreCell" bundle:nil] forCellReuseIdentifier:@"MemoryMoreCell"];
}
- (void)loadMemoryList:(NSInteger)index{
    //    {
    //        "userPhone":"*****",        #用户手机号
    //        "token":"*****",            #登陆凭证
    //        "pageIndex":1               #记忆法页数
    //    }
    if (index == 1) {
        [YHHud showWithStatus];
    }
    NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,    //    #用户手机号
                              @"token":self.token,         //   #登陆凭证
                              @"pageIndex":@"1"};       //        #记忆法页数
    [YHWebRequest YHWebRequestForPOST:kMemoryVideo parameters:jsonDic success:^(NSDictionary *json) {
        if (index == 1) {
            [YHHud dismiss];
        }
        if ([json[@"code"] integerValue] == 200) {
            NSArray *resultArr = [NSDictionary dictionaryWithJsonString:json[@"data"]][@"indexMemory"];
            _memoryVideoList = [NSMutableArray array];
            for (NSDictionary *memoryDic in resultArr) {
                if ([memoryDic[@"payType"] integerValue] == 1) {
                    [_memoryVideoList addObject:memoryDic];
                }
            }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _memory = [Memory yy_modelWithJSON:_memoryVideoList[indexPath.row]];
    [self performSegueWithIdentifier:@"MySubToMemoryDetail" sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MySubToMemoryDetail"]) {
        MemoryDetailVC *detailVC = segue.destinationViewController;
        detailVC.memory = _memory;
        detailVC.delegate = self;
    }
}
- (void)reloadMemoryList{
    [self loadMemoryList:0];
}

@end
