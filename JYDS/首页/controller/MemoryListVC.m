//
//  MemoryListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/11.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryListVC.h"
#import "MemoryMoreCell.h"
#import "MemoryDetailVC.h"
#import "Memory.h"
#import "SubAlertView.h"
#import "PayViewController.h"
#import "UILabel+Utils.h"
@interface MemoryListVC ()<UITableViewDelegate,UITableViewDataSource,SubAlertViewDelegate,MemoryDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *memoryVideoList;
@property (strong,nonatomic) Memory *memory;
@property (strong,nonatomic) JCAlertView *alertView;
@end

@implementation MemoryListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMemoryList) name:@"updateMemorySubStatus" object:nil];
    [_tableView registerNib:[UINib nibWithNibName:@"MemoryMoreCell" bundle:nil] forCellReuseIdentifier:@"MemoryMoreCell"];
    [self loadMemoryList];
}
- (void)loadMemoryList{
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _memory = [Memory yy_modelWithJSON:_memoryVideoList[indexPath.row]];
    if ([_memory.payType isEqualToString:@"0"]) {
        SubAlertView *subAlertView = [[SubAlertView alloc] initWithNib];
        NSString *str = [NSString stringWithFormat:@"订阅%@仅需100元!",_memory.title];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ORANGERED,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] range:NSMakeRange(str.length-5, 3)];
        subAlertView.label_0.attributedText = attStr;
        subAlertView.label_1.text = [NSString stringWithFormat:@"最多可邀请5个好友，订阅%@价格低至100元。",_memory.title];
        [subAlertView.label_1 setText:subAlertView.label_1.text lineSpacing:7.0f];
        subAlertView.delegate = self;
        _alertView = [[JCAlertView alloc] initWithCustomView:subAlertView dismissWhenTouchedBackground:NO];
        [_alertView show];
    }else{
        [self performSegueWithIdentifier:@"toMemoryDetail" sender:self];
    }
}
#pragma mark 继续订阅
- (void)continueSubClick{
    [_alertView dismissWithCompletion:^{
        [self performSegueWithIdentifier:@"memoryListToPayVC" sender:self];
    }];
}
#pragma mark 邀请好友
- (void)invitateFriendClick{
    [_alertView dismissWithCompletion:^{
        [self performSegueWithIdentifier:@"memoryListToInviteRewards" sender:self];
    }];
}
#pragma mark 关闭提示框
- (void)closeClick{
    [_alertView dismissWithCompletion:nil];
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toMemoryDetail"]) {
        MemoryDetailVC *detailVC = segue.destinationViewController;
        detailVC.delegate = self;
        detailVC.memory = _memory;
    }else if ([segue.identifier isEqualToString:@"memoryListToPayVC"]){
        PayViewController *payVC = segue.destinationViewController;
        payVC.memoryId = _memory.memoryId;
        payVC.payType = @"1";  // #购买类型 0：K12课程单词购买 1：记忆法课程购买
        [YHSingleton shareSingleton].payType = @"1";
    }
}
- (void)reloadMemoryList{
    [self loadMemoryList];
}
@end
