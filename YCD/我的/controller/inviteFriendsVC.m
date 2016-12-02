//
//  inviteFriendsVC.m
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "inviteFriendsVC.h"

@interface inviteFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *inviteCodeButton;
- (IBAction)inviteCodeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendToFriendButton;
- (IBAction)sendToFriendClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *rewardRulesLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *tableViewArray;
@end

@implementation inviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //点击复制互学码按钮
    self.inviteCodeButton.layer.masksToBounds = YES;
    self.inviteCodeButton.layer.cornerRadius = 8.0f;
    self.inviteCodeButton.layer.borderWidth = 1.0f;
    self.inviteCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //发送给好友按钮
    self.sendToFriendButton.layer.masksToBounds = YES;
    self.sendToFriendButton.layer.cornerRadius = 8.0f;
    self.sendToFriendButton.layer.borderWidth = 1.0f;
    self.sendToFriendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //邀请规则
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.rewardRulesLabel.text];
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
    [content addAttributes:attributeDic range:NSMakeRange(self.rewardRulesLabel.text.length-4, 4)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.rewardRulesLabel.text.length)];
    self.rewardRulesLabel.attributedText = content;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}
- (NSArray *)tableViewArray{
    if (!_tableViewArray) {
        _tableViewArray = @[@"用户 139****1231 加入易词典，您获得了5个学习豆",@"用户 139****1231 加入易词典，您获得了5个学习豆",@"用户 139****1231 加入易词典，您获得了5个学习豆"];
    }
    return _tableViewArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = self.tableViewArray[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
#pragma mark 点击复制互学码
- (IBAction)inviteCodeClick:(UIButton *)sender {
}
#pragma mark 点击发送给好友
- (IBAction)sendToFriendClick:(UIButton *)sender {
}
@end
