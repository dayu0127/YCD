//
//  RememberWordItemVC.m
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordItemVC.h"
#import "RememberWordVideoCell.h"
#import "RememberWordSingleWordCell.h"
#import "RememberWordVideoDetailVC.h"
#import "RememberWordSingleWordDetailVC.h"
#import "CourseVideo.h"
#import "Words.h"
#import <UIImageView+WebCache.h>
#import "PayVC.h"

@interface RememberWordItemVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate,RememberWordVideoDetailVCDelegate,RememberWordSingleWordDetailVCDelegate>

@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (assign,nonatomic) NSInteger flagForTable;    //切换视频和单个词语tableView的标记
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *wordArray;
@property (strong,nonatomic) NSArray *courseUrlArray;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;
@property (strong,nonatomic) JCAlertView *alertView;
@property (assign,nonatomic) NSInteger allVideoPrice;
@property (assign,nonatomic) NSInteger allWordPrice;

@end
@implementation RememberWordItemVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBarButton.hidden = NO;
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _wordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _footerBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _subscriptionLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [self initTableView];
    [self setTableView];
}
#pragma mark 初始化TableView
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 116, WIDTH, HEIGHT-160) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
- (void)initVideoSubContent{
    _allVideoPrice = 0;
    for (NSDictionary *dic in _courseVideoArray) {
        if ([dic[@"productType"] integerValue] == 0) {
            _allVideoPrice += [dic[@"videoPrice"] integerValue];
        }
    }
    self.subscriptionLabel.text = [NSString stringWithFormat:@"一次订阅所有%@的视频教程,仅需%zd学习豆!",self.navTitle,_allVideoPrice];
}
- (IBAction)videoClick:(UIButton *)sender{
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _wordButton.selected = NO;
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _flagForTable = 0;
    [self setTableView];
}
- (IBAction)wordClick:(UIButton *)sender{
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.selected = NO;
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _flagForTable = 1;
    [self setTableView];
}
#pragma mark 设置TableView数据源
- (void)setTableView{
    if (_flagForTable == 0) {
        //计算tableView的高度
        CGFloat h = 0;
        NSInteger count = 0;
        for (NSDictionary *dic in _courseVideoArray) {
            if ([dic[@"productType"] integerValue] == 1) {
                count++;
            }
        }
        if (count == _courseVideoArray.count) {
            h =  HEIGHT-116;
            _footerBgView.alpha = 0;
        }else{
            h = HEIGHT-160;
            _footerBgView.alpha = 1;
        }
        _tableView.frame = CGRectMake(0, 116, WIDTH, h);
        [_tableView registerNib:[UINib nibWithNibName:@"RememberWordVideoCell" bundle:nil] forCellReuseIdentifier:@"RememberWordVideoCell"];
        [_tableView reloadData];
        [self initVideoSubContent];
    }else{
        if (_wordArray == nil) {
            NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID};
            [YHWebRequest YHWebRequestForPOST:WORD parameters:dic success:^(NSDictionary *json) {
                if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                    _wordArray = [NSMutableArray arrayWithArray:json[@"data"]];
                    [self initWordTable];
                }
            }];
        }else{
            [self initWordTable];
        }
    }
}
- (void)initWordTable{
    _allWordPrice = 0;
    CGFloat h = 0;
    NSInteger count = 0;
    NSInteger subCount = 0;
    for (NSDictionary *dic in _wordArray) {
        NSArray *wordArray = dic[@"wordData"];
        count+=wordArray.count;
        for (NSDictionary *item in wordArray) {
            if ([item[@"payType"] integerValue] == 0) {
                _allWordPrice += [item[@"wordPrice"] integerValue];
            }else{
                subCount++;
            }
        }
    }
    if (count == subCount) {
        h =  HEIGHT-116;
        _footerBgView.alpha = 0;
    }else{
        h = HEIGHT-160;
        _footerBgView.alpha = 1;
    }
    _tableView.frame = CGRectMake(0, 116, WIDTH, h);
    [_tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
    [_tableView reloadData];
    self.subscriptionLabel.text = [NSString stringWithFormat:@"一次订阅所有%@的视频教程,仅需%zd学习豆!",self.navTitle,_allWordPrice];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _flagForTable == 0 ? 1 : self.wordArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.wordArray[section][@"wordData"];
    NSInteger rowNumber = 0;
    if (_flagForTable == 0) {
       rowNumber =  _courseVideoArray.count;
    }else{
        rowNumber = arr.count;
    }
    return rowNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _flagForTable == 0 ? 10 : 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _flagForTable == 0 ? 70 : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = nil;
    if (_flagForTable == 1) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.text = _wordArray[section][@"Title"];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return titleLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flagForTable == 0) {
        RememberWordVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordVideoCell" forIndexPath:indexPath];
        [cell addModelWithDic:self.courseVideoArray[indexPath.row]];
        return cell;
    }else{
        RememberWordSingleWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordSingleWordCell" forIndexPath:indexPath];
        [cell addModelWithDic:self.wordArray[indexPath.section][@"wordData"][indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_flagForTable == 0) {
        RememberWordVideoDetailVC *videoDetailVC = [[RememberWordVideoDetailVC alloc] init];
        videoDetailVC.hidesBottomBarWhenPushed = YES;
        videoDetailVC.video = [CourseVideo yy_modelWithJSON:self.courseVideoArray[indexPath.row]];
        videoDetailVC.videoArray = self.courseVideoArray;
        videoDetailVC.delegate = self;
        [self.navigationController pushViewController:videoDetailVC animated:YES];
    }else{
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:self.wordArray[indexPath.section][@"wordData"][indexPath.row]];
        wordDetailVC.delegate = self;
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}
- (void)reloadVideoList{
    NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID};
    [YHWebRequest YHWebRequestForPOST:COURSEVIDEO parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _courseVideoArray = json[@"data"];
            [_tableView registerNib:[UINib nibWithNibName:@"RememberWordVideoCell" bundle:nil] forCellReuseIdentifier:@"RememberWordVideoCell"];
            [_tableView reloadData];
        }
    }];
}
- (void)reloadWordList{
    [self setTableView];
}
- (IBAction)subscriptionClick:(id)sender {
    NSString *str = _flagForTable == 0 ? @"视频课程" : @"单词";
    NSString *message = [NSString stringWithFormat:@"如果确定，将一次订阅当前所有%@",str];
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:message];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_flagForTable == 0) {//全部k12视频订阅
            //学习豆不足
            if (_allVideoPrice>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
                [self pushPayVC];
            }else{
                //学习豆充足
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"payStudyBean":[NSString stringWithFormat:@"%zd",_allVideoPrice],@"type":@"k12",@"classifyID":_classifyID};
                [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                        _tableView.frame = CGRectMake(0, 116, WIDTH, HEIGHT-116);
                        _footerBgView.alpha = 0;
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:_courseVideoArray];
                        for (NSInteger i = 0; i<arr.count; i++) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:i]];
                            [dic setObject:[NSNumber numberWithInt:1] forKey:@"productType"];
                            [arr replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
                        }
                        _courseVideoArray = [NSArray arrayWithArray:arr];
                        [_tableView reloadData];
                        [YHHud showWithSuccess:@"订阅成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadVideos" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBean" object:nil];
                    }
                }];
            }
        }else{//全部单词订阅
            //学习豆不足
            if (_allWordPrice>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
                [self pushPayVC];
            }else{
                //学习豆充足
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"payStudyBean":[NSString stringWithFormat:@"%zd",_allWordPrice],@"type":@"words",@"classifyID":_classifyID};
                NSLog(@"%@",dic);
                [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
                     NSLog(@"%@",json);
                    if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                        _tableView.frame = CGRectMake(0, 116, WIDTH, HEIGHT-116);
                        _footerBgView.alpha = 0;
                        for (NSInteger i = 0; i<_wordArray.count; i++) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[_wordArray objectAtIndex:i]];
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:@"wordData"]];
                            for (NSInteger j = 0; j<arr.count; j++) {
                                NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:j]];
                                [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
                                [arr replaceObjectAtIndex:j withObject:[NSDictionary dictionaryWithDictionary:item]];
                            }
                            [dic setObject:arr forKey:@"wordData"];
                            [_wordArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:dic]];
                        }
                        [_tableView reloadData];
                        [YHHud showWithSuccess:@"订阅成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWords" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBean" object:nil];
                    }
                }];
            }
        }
    }
    [_alertView dismissWithCompletion:nil];
}
- (void)pushPayVC{
    [YHHud showWithMessage:@"您的学习豆不足，请充值"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
        payVC.isHiddenNav = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    });
}
#pragma mark 秒->时 分 秒
-(NSString *)getHMSFromS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_hour = [NSString stringWithFormat:@"%02zd",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02zd",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02zd",seconds%60];
    NSString *format_time = @"";
    if ((![str_hour isEqualToString:@"00"])&&(![str_minute isEqualToString:@"00"])) {
        format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    }else if ([str_hour isEqualToString:@"00"]&&(![str_minute isEqualToString:@"00"])){
        format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
    }else if ([str_hour isEqualToString:@"00"]&&[str_minute isEqualToString:@"00"]){
        format_time = [NSString stringWithFormat:@"%@秒",str_second];
    }
    return format_time;
}
@end
