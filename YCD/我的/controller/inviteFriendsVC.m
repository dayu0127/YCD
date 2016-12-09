//
//  inviteFriendsVC.m
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "inviteFriendsVC.h"

@interface inviteFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteCodeButton;
- (IBAction)inviteCodeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendToFriendButton;
- (IBAction)sendToFriendClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *rewardRulesLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *rewardsRecordLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (strong,nonatomic) NSArray *tableViewArray;
@end

@implementation inviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [_inviteCodeButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _inviteCodeButton.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _sendToFriendButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    //点击复制互学码按钮
    _inviteCodeButton.layer.masksToBounds = YES;
    _inviteCodeButton.layer.cornerRadius = 5.0f;
    _inviteCodeButton.layer.borderWidth = 1.0f;
    _inviteCodeButton.layer.dk_borderColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    //发送给好友按钮
    _sendToFriendButton.layer.masksToBounds = YES;
    _sendToFriendButton.layer.cornerRadius = 5.0f;
    //邀请规则
    _rewardRulesLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],RED);
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.rewardRulesLabel.text];
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
    [content addAttributes:attributeDic range:NSMakeRange(self.rewardRulesLabel.text.length-4, 4)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.rewardRulesLabel.text.length)];
    _rewardRulesLabel.attributedText = content;
    _rewardsRecordLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _line.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
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
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.tableViewArray[indexPath.row];
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
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
