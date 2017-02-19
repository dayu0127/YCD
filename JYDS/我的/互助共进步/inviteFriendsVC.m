//
//  inviteFriendsVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "inviteFriendsVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialResponse.h>

@interface inviteFriendsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *sendToFriendButton;
@property (weak, nonatomic) IBOutlet UILabel *rewardRulesLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *rewardsRecordLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (strong,nonatomic) NSArray *tableViewArray;
@end

@implementation inviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    //点击复制互学码按钮
    _inviteCodeButton.layer.masksToBounds = YES;
    _inviteCodeButton.layer.cornerRadius = 5.0f;
    _inviteCodeButton.layer.borderWidth = 1.0f;
    [_inviteCodeButton setTitle:[YHSingleton shareSingleton].userInfo.studyCode forState:UIControlStateNormal];
    //发送给好友按钮
    _sendToFriendButton.layer.masksToBounds = YES;
    _sendToFriendButton.layer.cornerRadius = 5.0f;
    //邀请规则
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.rewardRulesLabel.text];
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
    [content addAttributes:attributeDic range:NSMakeRange(self.rewardRulesLabel.text.length-4, 4)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.rewardRulesLabel.text.length)];
    _rewardRulesLabel.attributedText = content;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}
- (void)nightModeConfiguration{
    _inviteCodeButton.layer.dk_borderColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rewardRulesLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],RED);
    _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [_inviteCodeButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _inviteCodeButton.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _sendToFriendButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _rewardsRecordLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _line.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _tableView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
}
- (NSArray *)tableViewArray{
    if (!_tableViewArray) {
        _tableViewArray = @[@"用户 139****1231 加入记忆大师，您获得了5个学习豆",@"用户 139****1231 加入记忆大师，您获得了5个学习豆",@"用户 139****1231 加入记忆大师，您获得了5个学习豆"];
    }
    return _tableViewArray;
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
#pragma mark 点击复制互学码
- (IBAction)inviteCodeClick:(UIButton *)sender {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:sender.titleLabel.text];
    [YHHud showWithMessage:@"互学码已复制到剪贴板"];
}
#pragma mark 设置分享内容
#pragma mark 分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"记忆大师分享内容";
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
#pragma mark 分享错误信息提示
- (void)alertWithError:(NSError *)error{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }else{
        if (error) {
            result = [NSString stringWithFormat:@"分享被取消"];
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    [YHHud showWithMessage:result];
}
#pragma mark 点击发送给好友
- (IBAction)sendToFriendClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_Sina) {
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_Sina];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_QQ];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareTextToPlatformType:UMSocialPlatformType_Qzone];
        }
    }];
}
@end
