//
//  MessageCenterVC.m
//  JYDS
//
//  Created by liyu on 2017/6/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MessageCenterVC.h"
#import "MessageCenterCell.h"
#import "MessageVC.h"
@interface MessageCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *imageArr;
@property (strong,nonatomic) NSArray *messgaList;
@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YHHud showWithStatus];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageCenterCell" bundle:nil] forCellReuseIdentifier:@"MessageCenterCell"];
    _imageArr = @[@"message_sys",@"message_active",@"message_guan",];
    _messgaList = @[@{@"title":@"系统通知",@"detail":@"阿萨德发的法师打发打发打发打发地方大师傅"},
                    @{@"title":@"活动通知",@"detail":@"阿萨德发的法师打发打发打发打发地方大师傅"},
                    @{@"title":@"官方通知",@"detail":@"阿萨德发的法师打发打发打发打发地方大师傅"}];
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [YHWebRequest YHWebRequestForPOST:@"" parameters:nil success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _messgaList = jsonData[@""];
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
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messgaList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCenterCell" forIndexPath:indexPath];
    cell.messageImage.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    [cell setModel:_messgaList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"messageCenterToList" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"messageCenterToList"]) {
        MessageVC *messageVC = segue.destinationViewController;
        
    }
}


@end
