//
//  MessageVC.m
//  JYDS
//
//  Created by liyu on 2017/3/30.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *noticeList;
@property (copy,nonatomic) NSString *messageTitle;
@property (copy,nonatomic) NSString *messageUrl;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YHHud showWithStatus];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [YHWebRequest YHWebRequestForPOST:kNoticeList parameters:nil success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _noticeList = jsonData[@"getNoticeList"];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [YHHud dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _noticeList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46/71.0*WIDTH+33;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    [cell setModel:_noticeList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseNavViewController *messageDetailVC = [[BaseNavViewController alloc] init];
    messageDetailVC.isShowShareBtn = NO;
    messageDetailVC.navTitle = _noticeList[indexPath.row][@"n_title"];
    messageDetailVC.linkUrl = _noticeList[indexPath.row][@"n_content"];
    messageDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

@end
