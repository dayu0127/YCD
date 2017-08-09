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
#import <ZFPlayerControlView.h>
#import <UIView+CustomControlView.h>
//#import "YHMonitorKeyboard.h"
#import "UITextView+Utils.h"
#import "GradeVC.h"
@interface MemoryDetailVC ()<ZFPlayerDelegate,ZFPlayerControlViewDelagate>
@property (weak, nonatomic) IBOutlet UIView *playFatherView;
@property (nonatomic,strong) ZFPlayerView *playerView;
@property (nonatomic,strong) ZFPlayerModel *playerModel;
@property (weak, nonatomic) IBOutlet UIView *detailBgView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memoryCollect;
@property (weak, nonatomic) IBOutlet UILabel *issueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong,nonatomic) NSArray *memoryCommentList;
//@property (weak, nonatomic) IBOutlet UIView *commentBgView;
//@property (weak, nonatomic) IBOutlet UIView *borderView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBgViewBottomSpace;
//@property (weak, nonatomic) IBOutlet UITextField *commentTxt;
@property (strong,nonatomic) NSURL *videoURL;
@property (assign,nonatomic) NSInteger isZan;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) UITextView *detailTextView;
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
        _playerModel.videoURL         = [NSURL URLWithString:_memory.videoUrl];
//        _playerModel.placeholderImage = [UIImage imageNamed:@"home_memoryImg"];
        _playerModel.placeholderImageURLString = _memory.imgUrl;
        _playerModel.fatherView       = self.playFatherView;
    }
    return _playerModel;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView pause];
//    {
//        "userPhone":"******"    #用户手机号
//        "token":"****"          #登陆凭证
//        "memoryId"："****"       #记忆法视频id
//    }
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,   // #用户手机号
        @"token":self.token,      //    #登陆凭证
        @"memoryId":_memory.memoryId,    //   #记忆法视频id
    };
    [YHWebRequest YHWebRequestForPOST:kPlayNum parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            [_delegate reloadMemoryList];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    _commentBgView.alpha = 0;
    //播放器
    _playerView = [[ZFPlayerView alloc] init];
    _playerView.delegate = self;
    ZFPlayerControlView *pvc = [[ZFPlayerControlView alloc] init];
    pvc.backBtn.hidden = YES;
    [_playerView playerControlView:pvc playerModel:self.playerModel];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
//    _borderView.layer.masksToBounds = YES;
//    _borderView.layer.cornerRadius = 18.5f;
//    _borderView.layer.borderColor = LIGHTGRAYCOLOR.CGColor;
//    _borderView.layer.borderWidth = 1.0f;
    _videoTitleLabel.text = _memory.title;
    _likeCountLabel.text = [NSString convertWanFromNum:_memory.likes];
//    if (_isLike == YES) {
//        [_memoryCollect setImage:[UIImage imageNamed:@"course_collected"]];
//        _likeButton.enabled = NO;
//    }else{
//        [_memoryCollect setImage:[UIImage imageNamed:@"course_collect"]];
//        _likeButton.enabled = YES;
//    }
    NSString *timeStr = [_memory.create_time componentsSeparatedByString:@" "][0];
    NSArray *dateArr = [timeStr componentsSeparatedByString:@"-"];
    _issueTimeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日发布",dateArr[0],dateArr[1],dateArr[2]];
    NSString *playCountStr = [NSString convertWanFromNum:_memory.views];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放",playCountStr];
    //详情
    _detailTextView = [UITextView new];
    _detailTextView.text = _memory.content;
    CGFloat h = [_memory.content boundingRectWithSize:CGSizeMake(WIDTH-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0f] forKey:NSFontAttributeName] context:nil].size.height;
    h += (h/14.0+2)*5;
    _detailTextView.font = [UIFont systemFontOfSize:14.0f];
    _detailTextView.textColor = DGRAYCOLOR;
    _detailTextView.editable = NO;
    _detailTextView.selectable = NO;
    [_detailTextView setText:_memory.content lineSpacing:5];
    [_detailBgView addSubview:_detailTextView];
    [_detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playCountLabel.mas_bottom).offset(7);
        make.left.equalTo(self.detailBgView).offset(10);
        make.right.equalTo(self.detailBgView).offset(-10);
        make.height.mas_equalTo(@(h));
    }];
    UIView *line = [UIView new];
    line.backgroundColor = LINECOLOR;
    [_detailBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_detailTextView.mas_bottom);
        make.left.right.equalTo(_detailBgView);
        make.height.mas_equalTo(@10);
    }];
    //立即体验课程记忆
    if ([_memory.title isEqualToString:@"英文记忆"]) {
        UIButton *gotoCourseMemory = [UIButton buttonWithType:UIButtonTypeSystem];
        [gotoCourseMemory setTitle:@"立即体验课程记忆"forState:UIControlStateNormal];
        [gotoCourseMemory setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        gotoCourseMemory.backgroundColor = ORANGERED;
        gotoCourseMemory.layer.masksToBounds = YES;
        gotoCourseMemory.layer.cornerRadius = 3.0f;
        gotoCourseMemory.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [gotoCourseMemory addTarget:self action:@selector(gotoCourseMemoryClick) forControlEvents:UIControlEventTouchUpInside];
        [_detailBgView addSubview:gotoCourseMemory];
        CGFloat w = 211/375.0*WIDTH;
        [gotoCourseMemory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(17);
            make.centerX.equalTo(_detailBgView);
            make.width.mas_equalTo(@(w));
            make.height.mas_equalTo(@47);
        }];
    }
//    [self getCommentList];
    //监听键盘弹出和消失
//    [YHMonitorKeyboard YHAddMonitorWithShowBack:^(NSInteger height) {
//        [UIView animateWithDuration:1 animations:^{
//            _commentBgViewBottomSpace.constant = height;
//        }];
//    } andDismissBlock:^(NSInteger height) {
//        [UIView animateWithDuration:1 animations:^{
//            _commentBgViewBottomSpace.constant = 0;
//        }];
//    }];
}

- (void)gotoCourseMemoryClick{
    [self performSegueWithIdentifier:@"memoryDetailToGradeList" sender:self];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"memoryDetailToGradeList"]) {
        GradeVC *gradeVC = segue.destinationViewController;
        gradeVC.grade_type = @"1";
    }
}
//- (void)getCommentList{
////    {
////        "userPhone":"******"    #用户手机号
////        "token":"****"          #登陆凭证
////        "pageIndex":1           #页数
////        "memoryId":"***"        #记忆法id（选填，与commenId二选一）
////        "commenId":"****"       #评论id（选填，与memoryId二选一）
////    }
//    NSDictionary *jsonDic = @{
//        @"userPhone":self.phoneNum,   //    #用户手机号
//        @"token":self.token,   //          #登陆凭证
//        @"pageIndex":@"1",   //           #页数
//        @"memoryId":_memory.memoryId   //        #记忆法id（选填，与commenId二选一）
////     @"commenId":"****"     //    #评论id（选填，与memoryId二选一）
//    };
//    [YHWebRequest YHWebRequestForPOST:kMemoryCommentList parameters:jsonDic success:^(NSDictionary *json) {
//        if ([json[@"code"] integerValue] == 200) {
//            NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
//            _memoryCommentList = dataDic[@"commentList"];
//            [_tableView reloadData];
//        }else{
//            NSLog(@"%@",json[@"code"]);
//            [YHHud showWithMessage:json[@"message"]];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _memoryCommentList.count;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 157;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
//    [cell addModelWithDic:_memoryCommentList[indexPath.row]];
//    if (_memoryCommentList.count == 1) {
//        cell.sepLine.alpha = 0;
//    }
//    return cell;
//}
#pragma mark 记忆法点赞
- (IBAction)memoryLikesClick:(UIButton *)sender {
    if (_isZan == 0) {
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
                //改变该视频在本地的点赞状态
//                NSMutableDictionary *likesDic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"likesDic"]];
//                [likesDic setObject:@"1" forKey:_memory.memoryId];
//                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:likesDic] forKey:@"likesDic"];
                _likeCountLabel.alpha = 0;
                _memoryCollect.image = [UIImage imageNamed:@"course_collected"];
//                NSInteger count = [_likeCountLabel.text integerValue];
//                count++;
//                _likeCountLabel.text = [NSString stringWithFormat:@"%zd",count];
//                _isZan = 1;
                [_delegate reloadMemoryList];
                [YHHud showWithMessage:@"点赞成功"];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
//#pragma mark 发送评论
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if ([textField.text isEqualToString:@""]) {
//        return NO;
//    }else{
////        {
////            "userPhone":"******"    #用户手机号
////            "token":"****"          #登陆凭证
////            "commentType"："**"      #评论类型 memory：记忆法视频轮 word：单词评论  非上面两种类型为评论他人评论
////            "objectId":             #评论目标的ID
////        }
//        NSDictionary *jsonDic = @{
//            @"userPhone":self.phoneNum,  //    #用户手机号
//            @"token":self.token,    //      #登陆凭证
//            @"commentType":@"memory",    //  #评论类型 memory：记忆法视频轮 word：单词评论  非上面两种类型为评论他人评论
//            @"objectId":_memory.memoryId,
//            @"content":textField.text    //       #评论目标的ID
//        };
//        [YHWebRequest YHWebRequestForPOST:kUserComment parameters:jsonDic success:^(NSDictionary *json) {
//            if ([json[@"code"] integerValue] == 200) {
//                textField.text = @"";
//                [self.view endEditing:YES];
//                [YHHud showWithSuccess:@"评论成功"];
//            }else{
//                NSLog(@"%@",json[@"code"]);
//                [YHHud showWithMessage:json[@"message"]];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//        }];
//        return YES;
//    }
//}
@end
