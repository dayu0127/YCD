//
//  MemoryDetailVC.m
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryDetailVC.h"
#import "CommentCell.h"
#import <ZFPlayer.h>
#import "YHMonitorKeyboard.h"
@interface MemoryDetailVC ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *playFatherView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (weak, nonatomic) IBOutlet UIView *studentDemoView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memoryCollect;
@property (weak, nonatomic) IBOutlet UILabel *issueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoContent;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *memoryCommentList;
@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBgViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITextField *commentTxt;
@end

@implementation MemoryDetailVC
// 返回值要必须为NO
- (BOOL)shouldAutorotate{
    return NO;
}
- (ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = _memory.title;
        _playerModel.videoURL         = [NSURL URLWithString:_memory.url];
//        _playerModel.placeholderImageURLString = [UIImage imageNamed:@"home_memoryImg"];
        _playerModel.placeholderImage = [UIImage imageNamed:@"home_memoryImg"];
        _playerModel.fatherView       = self.playFatherView;
    }
    return _playerModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //播放器
    _playerView = [[ZFPlayerView alloc] init];
    _playerView.delegate = self;
    ZFPlayerControlView *playerControlView = [[ZFPlayerControlView alloc] init];
    playerControlView.backBtn.hidden = YES;
    [_playerView playerControlView:playerControlView playerModel:self.playerModel];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    _borderView.layer.masksToBounds = YES;
    _borderView.layer.cornerRadius = 18.5f;
    _borderView.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
    _borderView.layer.borderWidth = 1.0f;
    _videoTitleLabel.text = _memory.title;
    _likeCountLabel.text = _memory.likes;
    NSString *timeStr = [_memory.create_time componentsSeparatedByString:@" "][0];
    NSArray *dateArr = [timeStr componentsSeparatedByString:@"-"];
    _issueTimeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日发布",dateArr[0],dateArr[1],dateArr[2]];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放",_memory.views];
    _videoContent.text = _memory.content;
    [_playerView playerControlView:nil playerModel:self.playerModel];
    [self getCommentList];
    //监听键盘弹出和消失
    [YHMonitorKeyboard YHAddMonitorWithShowBack:^(NSInteger height) {
        [UIView animateWithDuration:1 animations:^{
            _commentBgViewBottomSpace.constant = height;
        }];
    } andDismissBlock:^(NSInteger height) {
        [UIView animateWithDuration:1 animations:^{
            _commentBgViewBottomSpace.constant = 0;
        }];
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getCommentList{
//    {
//        "userPhone":"******"    #用户手机号
//        "token":"****"          #登陆凭证
//        "pageIndex":1           #页数
//        "memoryId":"***"        #记忆法id（选填，与commenId二选一）
//        "commenId":"****"       #评论id（选填，与memoryId二选一）
//    }
    NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,   //    #用户手机号
                                          @"token":self.token,   //          #登陆凭证
                                          @"pageIndex":@"1",   //           #页数
                                          @"memoryId":_memory.memoryId};   //        #记忆法id（选填，与commenId二选一）
//                                          @"commenId":"****"     //    #评论id（选填，与memoryId二选一）
    [YHWebRequest YHWebRequestForPOST:kMemoryCommentList parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _memoryCommentList = dataDic[@"commentList"];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _memoryCommentList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    [cell addModelWithDic:_memoryCommentList[indexPath.row]];
    if (_memoryCommentList.count == 1) {
        cell.sepLine.alpha = 0;
    }
    return cell;
}
#pragma mark 记忆法点赞
- (IBAction)memoryLikesClick:(UIButton *)sender {
//    {
//        "userPhone":"******"    #用户手机号
//        "token":"****"          #登陆凭证
//        "memoryId"："****"       #记忆法视频id
//    }
    NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,    //    #用户手机号
                                          @"token":self.token,    //          #登陆凭证
                                          @"memoryId":_memory.memoryId};    //   #记忆法视频id
    [YHWebRequest YHWebRequestForPOST:kMemoryLikes parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            _memoryCollect.image = [UIImage imageNamed:@"course_collected"];
            NSInteger count = [_likeCountLabel.text integerValue];
            count++;
            _likeCountLabel.text = [NSString stringWithFormat:@"%zd",count];
            [_delegate reloadMemoryList];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 发送评论
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }else{
//        {
//            "userPhone":"******"    #用户手机号
//            "token":"****"          #登陆凭证
//            "commentType"："**"      #评论类型 memory：记忆法视频轮 word：单词评论  非上面两种类型为评论他人评论
//            "objectId":             #评论目标的ID
//        }
        NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,  //    #用户手机号
                                  @"token":self.token,    //      #登陆凭证
                                  @"commentType":@"memory",    //  #评论类型 memory：记忆法视频轮 word：单词评论  非上面两种类型为评论他人评论
                                  @"objectId":_memory.memoryId,
                                  @"content":textField.text};     //       #评论目标的ID
        [YHWebRequest YHWebRequestForPOST:kUserComment parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                textField.text = @"";
                [self.view endEditing:YES];
                [YHHud showWithSuccess:@"评论成功"];
            }else{
                NSLog(@"%@",json[@"code"]);
                NSLog(@"%@",json[@"message"]);
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        return YES;
    }
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
