//
//  SubscribedVC.m
//  JYDS
//
//  Created by dayu on 2016/11/25.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SubscribedVC.h"
#import "Words.h"
#import "RememberWordVideoCell.h"
#import "RememberWordVideoDetailVC.h"
#import "RememberWordSingleWordDetailVC.h"
#import "CourseVideo.h"
@interface SubscribedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *noVideoView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *videoArray;
@property (nonatomic,strong) NSArray *wordArray;
@property (nonatomic,strong) NSMutableDictionary *wordDic;
@property (assign,nonatomic) NSInteger flagForTable;    //切换已订阅的视频和单词tableView的标记

@end

@implementation SubscribedVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (_flagForTable == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoList) name:@"reloadVideos" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWordList) name:@"reloadVideos" object:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:@"已订阅"];
    [self nightModeConfiguration];
    [self initTableView];
    [self setTableView];
}
- (void)nightModeConfiguration{
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _wordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
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
#pragma mark 设置TableView数据源
- (void)setTableView{
    if (_flagForTable == 0) {
        [self.view endEditing:YES];
        if (_videoArray!=nil) {
            [_tableView registerNib:[UINib nibWithNibName:@"RememberWordVideoCell" bundle:nil] forCellReuseIdentifier:@"RememberWordVideoCell"];
        }else{
            [self loadVideoList];
        }
    }else{
        if (_wordArray!=nil) {
            [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
            [self wordSearch];
        }else{
            [self loadWordList];
        }
    }
    [_tableView reloadData];
}
- (void)loadVideoList{
    [YHWebRequest YHWebRequestForPOST:SUBVIDEO parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            if (self.noVideoView != nil) {
                [self.noVideoView removeFromSuperview];
                self.noVideoView = nil;
            }
            _videoArray = json[@"data"];
            [_tableView registerNib:[UINib nibWithNibName:@"RememberWordVideoCell" bundle:nil] forCellReuseIdentifier:@"RememberWordVideoCell"];
            [_tableView reloadData];
        }else if ([json[@"code"] isEqualToString:@"NOVIDEO"]){
            [self.view addSubview:self.noVideoView];
        }
    }];
}
- (void)loadWordList{
    [YHWebRequest YHWebRequestForPOST:SUBWORD parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            if (self.noVideoView != nil) {
                [self.noVideoView removeFromSuperview];
                self.noVideoView = nil;
            }
            _wordArray = json[@"data"];
            [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
            [self wordSearch];
            [_tableView reloadData];
        }else if ([json[@"code"] isEqualToString:@"NOWORD"]){
            [self.view addSubview:self.noVideoView];
        }
    }];
}
#pragma mark 懒加载暂无视频View
- (UIView *)noVideoView{
    if (!_noVideoView) {
        _noVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, WIDTH, HEIGHT-159)];
        _noVideoView.backgroundColor = [UIColor clearColor];
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*0.233, HEIGHT*0.104, WIDTH*0.533, WIDTH*0.32)];
        logoImageView.backgroundColor = [UIColor grayColor];
        [_noVideoView addSubview:logoImageView];
        //暂无视频Label
        UILabel *noVideoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame)+20, WIDTH, 15)];
        noVideoLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        noVideoLabel.text = @"暂无视频";
        noVideoLabel.textAlignment = NSTextAlignmentCenter;
        noVideoLabel.font = [UIFont systemFontOfSize:15.0f];
        [_noVideoView addSubview:noVideoLabel];
        //去订阅记忆法Button
        UIButton *toMemoryButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*0.233, CGRectGetMaxY(noVideoLabel.frame)+35, WIDTH*0.533, 35)];
        [toMemoryButton setTitle:@"去订阅记忆法" forState:UIControlStateNormal];
        [toMemoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        toMemoryButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        toMemoryButton.layer.masksToBounds = YES;
        toMemoryButton.layer.cornerRadius = 8.0f;
        toMemoryButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [toMemoryButton addTarget:self action:@selector(toMemoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_noVideoView addSubview:toMemoryButton];
        //去订阅单词视频课程Button
        UIButton *toWordVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*0.233, CGRectGetMaxY(toMemoryButton.frame)+20, WIDTH*0.533, 35)];
        [toWordVideoButton setTitle:@"去订阅单词视频课程" forState:UIControlStateNormal];
        [toWordVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        toWordVideoButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        toWordVideoButton.layer.masksToBounds = YES;
        toWordVideoButton.layer.cornerRadius = 8.0f;
        toWordVideoButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [toWordVideoButton addTarget:self action:@selector(toWordVideoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_noVideoView addSubview:toWordVideoButton];
    }
    return _noVideoView;
}
#pragma mark 视频按钮点击
- (IBAction)videoClick:(UIButton *)sender {
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _wordButton.selected = NO;
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    
    _flagForTable = 0;
    [self setTableView];
    if (self.noVideoView!=nil) {
        [self.noVideoView removeFromSuperview];
        self.noVideoView = nil;
    }
}
#pragma mark 单词按钮点击
- (IBAction)wordClick:(UIButton *)sender {
    [sender dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
    sender.selected = YES;
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.selected = NO;
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    
    _flagForTable = 1;
    [self setTableView];
    if (self.noVideoView!=nil) {
        [self.noVideoView removeFromSuperview];
        self.noVideoView = nil;
    }
}
#pragma mark 去订阅记忆法
- (void)toMemoryButtonClick{
    self.tabBarController.selectedIndex = 0;
}
#pragma mark 去订阅单词视频课程
- (void)toWordVideoButtonClick{
    self.tabBarController.selectedIndex = 1;
}
#pragma mark 侧边单词检索
- (void)wordSearch{
    //tableView右侧索引栏的字体颜色和背景色
    _tableView.dk_sectionIndexColorPicker = DKColorPickerWithColors(D_BTN_BG1,[UIColor whiteColor],RED);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //定义键的集合（26个字母）
    NSMutableArray *keyArr = [NSMutableArray array];
    [keyArr addObject:@"🔍"];
    for (int i = 97; i <= 122; i++) {
        [keyArr addObject:[NSString stringWithFormat:@"%c",(char)i]];
    }
    //定义值的集合(值为二维数组)
    NSMutableArray *objectArr = [NSMutableArray array];
    for (int i = 0; i < 27; i++) {
        [objectArr addObject:[NSMutableArray array]];
    }
    //定义放键值集合的字典
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:objectArr forKeys:keyArr];
    //根据单词的首字符放入对应的键所对应的值中 ("a"--"about","n"--"notification,nil",...)
    for (int i = 0 ; i < self.wordArray.count; i++) {
        NSDictionary *dic = self.wordArray[i];
        NSString *word = dic[@"word"];
        NSString *firstLetter = [NSString stringWithFormat:@"%c",[word characterAtIndex:0]];
        NSMutableArray *arr = dataDic[firstLetter];
        [arr addObject:dic];
    }
    //删除长度为0的值的集合
    for (NSString *letter in dataDic.allKeys) {
        NSMutableArray *arr = dataDic[letter];
        if (arr.count == 0) {
            [dataDic removeObjectForKey:letter];
        }
    }
    //组名集合排序
    NSMutableArray *sectionNameArr = [NSMutableArray arrayWithArray:dataDic.allKeys];
    [sectionNameArr sortUsingComparator:^NSComparisonResult(NSString *s1,NSString *s2){
        if ([s1 isEqual:@"🔍"]) {
            return [s2 compare:s1];
        }
        return [s1 compare:s2];
    }];
    //单词字典对象集合
    _wordDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < sectionNameArr.count; i++) {
        NSArray *wordObjectArr = dataDic[sectionNameArr[i]];
        [_wordDic setObject:wordObjectArr forKey:sectionNameArr[i]];
    }
//    @{@"A":@[@{@"wordID" : @"5",@"word" : @"subscribed"...},@{@"wordID" : @"5",@"word" : @"subscribed"...},...],
//       @"B":@[@{@"wordID" : @"5",@"word" : @"subscribed"...},@{@"wordID" : @"5",@"word" : @"subscribed"...},...],
//        .
//        .
//        .
//     }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _flagForTable == 0 ? 1 :_wordDic.allKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_flagForTable == 0){
        return _videoArray.count;
    }else{
        NSArray *wordArray = _wordDic.allValues[section];
        return wordArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _flagForTable == 0 ? 70 : 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_flagForTable == 0) {
        RememberWordVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordVideoCell" forIndexPath:indexPath];
        [cell addModelWithDic:_videoArray[indexPath.row]];
        cell.videoPrice.alpha = 0;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
        cell.textLabel.text = _wordDic.allValues[indexPath.section][indexPath.row][@"word"];
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_flagForTable == 0) {
        return 0.001;
    }else{
        return section == 0 ? 60 : 19.9;
    }
}
#pragma mark 右侧索引设置
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_flagForTable == 1) {
        NSMutableArray *arr = [NSMutableArray array];
        if (_wordArray != nil) {
            [arr addObject:@"🔍"];
            [arr addObjectsFromArray:_wordDic.allKeys];
        }
        return arr;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView;
    if (_flagForTable == 1) {
        if (0 == section) {
            headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60.0)];
            headView.backgroundColor = [UIColor clearColor];
            UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40.0)];
            search.placeholder = @"搜索单词";
            search.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
            [headView addSubview:search];
            UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 40, WIDTH, 19.9)];
            [sectionLabel setText:[_wordDic.allKeys[section] uppercaseString]];
            [sectionLabel setTextColor:[UIColor lightGrayColor]];
            sectionLabel.backgroundColor = [UIColor clearColor];
            [sectionLabel setFont:[UIFont systemFontOfSize:12.0]];
            [headView addSubview:sectionLabel];
        }else{
            headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 19.9)];
            headView.backgroundColor = [UIColor clearColor];
            UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, WIDTH, 19.9)];
            [sectionLabel setText:[_wordDic.allKeys[section] uppercaseString]];
            sectionLabel.backgroundColor = [UIColor clearColor];
            [sectionLabel setTextColor:[UIColor lightGrayColor]];
            [sectionLabel setFont:[UIFont systemFontOfSize:12.0]];
            [headView addSubview:sectionLabel];
        }
    }
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_flagForTable == 0) {
        RememberWordVideoDetailVC *videoDetailVC = [[RememberWordVideoDetailVC alloc] init];
        videoDetailVC.hidesBottomBarWhenPushed = YES;
        videoDetailVC.videoArray = _videoArray;
        videoDetailVC.video = [CourseVideo yy_modelWithJSON:_videoArray[indexPath.row]];
        [self.navigationController pushViewController:videoDetailVC animated:YES];
    }else{
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:_wordDic.allValues[indexPath.section][indexPath.row]];
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}
@end
