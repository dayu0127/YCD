//
//  RememberWordItemVC.m
//  YCD
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordItemVC.h"
#import "RememberWordVideoCell.h"
#import "RememberWordSingleWordCell.h"
#import "RememberWordVideoDetailVC.h"
#import "RememberWordSingleWordDetailVC.h"
#import "YHDataSource.h"
#import "CourseVideo.h"
#import <UIImageView+WebCache.h>
@interface RememberWordItemVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
- (IBAction)videoClick:(UIButton *)sender;
- (IBAction)wordClick:(UIButton *)sender;
@property (assign,nonatomic) NSInteger flagForTable;    //切换视频和单个词语tableView的标记
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *wordArray;
@property (strong,nonatomic) NSArray *courseUrlArray;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;
- (IBAction)subscriptionClick:(id)sender;
@property (strong,nonatomic) JCAlertView *alertView;
@property (strong,nonatomic) YHDataSource *dataSource;
@property (strong,nonatomic) NSMutableArray<CourseVideo *> *courseVideoModelArray;
@end

@implementation RememberWordItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _wordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _footerBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _subscriptionLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [self initTableView];
    if (WIDTH<=320) {
        _subscriptionLabel.numberOfLines=2;
    }
    NSLog(@"%@",_courseVideoArray);
}
- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        NSArray *arr = @[@{@"name":@"UNIT1",@"detail":@[@"merge",@"merge"]},
                         @{@"name":@"UNIT2",@"detail":@[@"merge",@"merge",@"merge",@"merge"]},
                         @{@"name":@"UNIT3",@"detail":@[@"merge",@"merge",@"merge"]},
                         @{@"name":@"UNIT4",@"detail":@[@"merge",@"merge",@"merge",@"merge"]}];
        _wordArray = [NSMutableArray arrayWithArray:arr];
    }
    return _wordArray;
}
#pragma mark 懒加载视频url数据
- (NSArray *)courseUrlArray{
    if (!_courseUrlArray) {
        _courseUrlArray = @[@"http://baobab.wdjcdn.com/14564977406580.mp4",
                            @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                            @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                            @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    }
    return _courseUrlArray;
}
- (IBAction)videoClick:(UIButton *)sender{
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _wordButton.selected = NO;
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _flagForTable = 0;
    [self initTableView];
    self.subscriptionLabel.text = @"一次订阅所有四年级上半年视频教程,仅需2000学习豆!";
}
- (IBAction)wordClick:(UIButton *)sender{
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.selected = NO;
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _flagForTable = 1;
    [self initTableView];
    self.subscriptionLabel.text = @"一次订阅所有四年级上半年所有单词,仅需2000学习豆!";
}
#pragma mark 初始化底部TableView
- (void)initTableView{
    if (_tableView != nil) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 116, WIDTH, HEIGHT-160) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    if (_flagForTable == 0) {
        _dataSource = [[YHDataSource alloc] initWithIdentifier:@"RememberWordVideoCell" configureBlock:^(RememberWordVideoCell *cell, CourseVideo *model, NSIndexPath *indexPath) {
            [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.videoImageUrl] placeholderImage:[UIImage imageNamed:@"videoImage"]];
            cell.videoName.text = model.videoName;
            cell.detailLabel.text = [NSString stringWithFormat:@"%@,共%@词",[self getHMSFromS:model.videoTime],model.videoWordNum];
            cell.videoPrice.text = [NSString stringWithFormat:@"%@学习豆",model.videoPrice];
        }];
        _courseVideoModelArray = [NSMutableArray array];
        for (NSDictionary *dic in _courseVideoArray) {
            [_courseVideoModelArray addObject:[CourseVideo yy_modelWithJSON:dic]];
        }
        [_dataSource addModels:_courseVideoModelArray];
        _tableView.dataSource = _dataSource;
        [_tableView registerNib:[UINib nibWithNibName:@"RememberWordVideoCell" bundle:nil] forCellReuseIdentifier:@"RememberWordVideoCell"];
    }else{
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _flagForTable == 0 ? 1 : self.wordArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.wordArray[section][@"detail"];
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
    return _flagForTable == 0 ? 80 : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = nil;
    if (_flagForTable == 1) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.text = _wordArray[section][@"name"];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return titleLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RememberWordSingleWordCell *cell;
    if (_flagForTable == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordSingleWordCell" forIndexPath:indexPath];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flagForTable == 0) {
//        RememberWordVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        RememberWordVideoDetailVC *videoDetailVC = [[RememberWordVideoDetailVC alloc] init];
        videoDetailVC.hidesBottomBarWhenPushed = YES;
        videoDetailVC.videoURL = [NSURL URLWithString:self.courseUrlArray[indexPath.row]];
        videoDetailVC.title = @"第一节课";
        [self.navigationController pushViewController:videoDetailVC animated:YES];
    }else{
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.videoURL = [NSURL URLWithString:self.courseUrlArray[indexPath.row]];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
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
        NSLog(@"确认订阅");
    }
    [_alertView dismissWithCompletion:nil];
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
