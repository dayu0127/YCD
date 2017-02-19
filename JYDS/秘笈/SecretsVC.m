//
//  SubscribedVC.m
//  JYDS
//
//  Created by dayu on 2016/11/25.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SecretsVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialResponse.h>
@interface SecretsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *ruleButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIView *ruleView;
@property (strong,nonatomic) UITableView *recordTableView;
@property (strong,nonatomic) NSArray *tableViewArray;

@end

@implementation SecretsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 115, WIDTH, HEIGHT-164)];
    _scrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT-164);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:self.ruleView];
    [_scrollView addSubview:self.recordTableView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.x == 0) {
        [self ruleButtonSelected];
    }else{
        [self recordButtonSelected];
    }
}
- (void)nightModeConfiguration{
    [_ruleButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_recordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _ruleButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _recordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
}

#pragma mark 规则按钮点击
- (IBAction)ruleClick:(UIButton *)sender {
    [self ruleButtonSelected];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark 记录按钮点击
- (IBAction)recordClick:(UIButton *)sender {
    [self recordButtonSelected];
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
}
- (void)ruleButtonSelected{
    [_ruleButton dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    _ruleButton.selected = YES;
    [_recordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _recordButton.selected = NO;
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
}
- (void)recordButtonSelected{
    [_recordButton dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    _recordButton.selected = YES;
    [_ruleButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _ruleButton.selected = NO;
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
}
#pragma mark 规则页面
- (UIView *)ruleView{
    if (!_ruleView) {
        _ruleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-164)];
        //您的邀请码
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, WIDTH, 17)];
        titleLabel.text = @"您的邀请码";
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_ruleView addSubview:titleLabel];
        //按钮
        UIButton *inviteCodeButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-145)*0.5, CGRectGetMaxY(titleLabel.frame)+15, 145, 37)];
        inviteCodeButton.layer.masksToBounds = YES;
        inviteCodeButton.layer.cornerRadius = 5.0f;
        inviteCodeButton.layer.borderWidth = 1.0f;
        inviteCodeButton.titleLabel.font = [UIFont systemFontOfSize:22.0f];
        [inviteCodeButton setTitle:[YHSingleton shareSingleton].userInfo.studyCode forState:UIControlStateNormal];
        inviteCodeButton.layer.dk_borderColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        [inviteCodeButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        inviteCodeButton.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
        [inviteCodeButton addTarget:self action:@selector(inviteCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ruleView addSubview:inviteCodeButton];
        //点击可复制
        UILabel *copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(inviteCodeButton.frame)+10, WIDTH, 14)];
        copyLabel.text = @"点击可复制";
        copyLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        copyLabel.font = [UIFont systemFontOfSize:14.0f];
        copyLabel.textAlignment = NSTextAlignmentCenter;
        [_ruleView addSubview:copyLabel];
        //发送给好友
        UIButton *sendToFriendButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-145)*0.5, CGRectGetMaxY(copyLabel.frame)+20, 145, 37)];
        sendToFriendButton.layer.masksToBounds = YES;
        sendToFriendButton.layer.cornerRadius = 5.0f;
        sendToFriendButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [sendToFriendButton setTitle:@"发送给好友" forState:UIControlStateNormal];
        [sendToFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendToFriendButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        [sendToFriendButton addTarget:self action:@selector(sendToFriendClick) forControlEvents:UIControlEventTouchUpInside];
        [_ruleView addSubview:sendToFriendButton];
        //邀请规则
        UILabel *rewardRulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sendToFriendButton.frame)+20, WIDTH-40, 50)];
        rewardRulesLabel.text = @"邀请好友加入记忆大师，每一位好友使用该互学码注册加入，双方均可获得5学习豆奖励。";
        rewardRulesLabel.font = [UIFont systemFontOfSize:12.0f];
        rewardRulesLabel.numberOfLines = 2;
        rewardRulesLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],RED);
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:rewardRulesLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, rewardRulesLabel.text.length)];
        rewardRulesLabel.attributedText = content;
        [_ruleView addSubview:rewardRulesLabel];
    }
    return _ruleView;
}
#pragma mark 记录页面
- (UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-164) style:UITableViewStylePlain];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recordTableView.backgroundColor = [UIColor clearColor];
         [_recordTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    }
    return _recordTableView;
}
#pragma mark 点击复制互学码
- (void)inviteCodeClick:(UIButton *)sender {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:sender.titleLabel.text];
    [YHHud showWithMessage:@"邀请码已复制到剪贴板"];
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
#pragma mark 发送给好友
- (void)sendToFriendClick{
    __weak typeof(self) weakSelf = self;
    //设置面板样式
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
    //预定义平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
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
@end
