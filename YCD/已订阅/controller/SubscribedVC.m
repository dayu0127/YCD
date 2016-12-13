//
//  SubscribedVC.m
//  YCD
//
//  Created by dayu on 2016/11/25.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SubscribedVC.h"
#import "RemeberWordSingleWordDetailVC.h"
#import "Singleton.h"

@interface SubscribedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
- (IBAction)videoClick:(UIButton *)sender;
- (IBAction)wordClick:(UIButton *)sender;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *noVideoView;
@property (nonatomic,strong) UITableView *wordTableView;
@property (nonatomic,strong) NSArray *courseUrlArray;
@property (nonatomic,strong) NSMutableArray *wordArray;
@property (nonatomic,strong) NSMutableArray *sectionNameArr;
@property (nonatomic,strong) NSMutableArray *nameArr;

@end

@implementation SubscribedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _wordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:self.noVideoView];
}
#pragma mark 懒加载字母数组
- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        NSArray *arr = @[@"about",@"because",@"code",@"discover",@"dispath",@"ever",@"forget",@"give",@"hour",@"italic",@"jump",@"keep",@"littl",@"mark",@"notification",@"open",@"present",@"queue",@"rules",@"storyboard",@"touch",@"underline",@"video",@"what",@"xerox",@"year",@"zero",@"red",@"prama",@"navigation",@"application",@"will",@"you",@"do",@"to",@"use",@"view",@"collection",@"pass",@"the",@"object",@"new",@"segue",@"often",@"set",@"remove",@"nil",@"get"];
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
#pragma mark 懒加载wordTableView
- (UITableView *)wordTableView{
    if (!_wordTableView) {
        _wordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, WIDTH, HEIGHT-159) style:UITableViewStyleGrouped];
        _wordTableView.delegate = self;
        _wordTableView.dataSource = self;
        _wordTableView.backgroundColor = [UIColor clearColor];
        _wordTableView.rowHeight = WORD_ROWHEIGHT;
        [_wordTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    }
    return _wordTableView;
}
#pragma mark 视频按钮点击
- (IBAction)videoClick:(UIButton *)sender {
    sender.selected = YES;
    _wordButton.selected = NO;
    self.leftLineView.backgroundColor = [UIColor orangeColor];
    self.rightLineView.backgroundColor = [UIColor clearColor];
    [self.wordTableView removeFromSuperview];
    self.wordTableView = nil;
    [self.view addSubview:self.noVideoView];
}
#pragma mark 去订阅记忆法
- (void)toMemoryButtonClick{
    self.tabBarController.selectedIndex = 0;
}
#pragma mark 去订阅单词视频课程
- (void)toWordVideoButtonClick{
    self.tabBarController.selectedIndex = 1;
}
#pragma mark 单词按钮点击
- (IBAction)wordClick:(UIButton *)sender {
    sender.selected = YES;
    _videoButton.selected = NO;
    self.rightLineView.backgroundColor = [UIColor orangeColor];
    self.leftLineView.backgroundColor = [UIColor clearColor];
    [self.noVideoView removeFromSuperview];
    self.noVideoView = nil;
    [self.view addSubview:self.wordTableView];
    [self wordSearch];
}
#pragma mark 侧边单词检索
- (void)wordSearch{
    //tableView右侧索引栏的字体颜色和背景色
    self.wordTableView.dk_sectionIndexColorPicker = DKColorPickerWithColors(D_BTN_BG1,[UIColor whiteColor],RED);
    self.wordTableView.sectionIndexBackgroundColor = [UIColor clearColor];
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
        NSString *word = [self.wordArray objectAtIndex:i];
        NSString *firstLetter = [NSString stringWithFormat:@"%c",[word characterAtIndex:0]];
        NSMutableArray *arr = dataDic[firstLetter];
        [arr addObject:word];
    }
    //删除长度为0的值的集合
    for (NSString *str in dataDic.allKeys) {
        NSMutableArray *arr = dataDic[str];
        if (arr.count == 0) {
            [dataDic removeObjectForKey:str];
        }
    }
    //组名集合排序
    _sectionNameArr = [NSMutableArray arrayWithArray:dataDic.allKeys];
    [_sectionNameArr sortUsingComparator:^NSComparisonResult(NSString *s1,NSString *s2){
        if ([s1 isEqual:@"🔍"]) {
            return [s2 compare:s1];
        }
        return [s1 compare:s2];
    }];
    //名字集合
    _nameArr = [NSMutableArray arrayWithCapacity:_sectionNameArr.count];
    for (int i = 0; i < _sectionNameArr.count; i++) {
        _nameArr[i] = dataDic[_sectionNameArr[i]];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _nameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arr = _nameArr[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    cell.textLabel.text = _nameArr[indexPath.section][indexPath.row];
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 60 : 19.9;
}

#pragma mark 右侧索引设置
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_sectionNameArr.count];
    [arr addObject:@"🔍"];
    for (NSString *sectionName in _sectionNameArr) {
        [arr addObject:[sectionName uppercaseString]];
    }
    return arr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionNameArr[section] uppercaseString];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView;
    if (0 == section) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60.0)];
        headView.backgroundColor = [UIColor clearColor];
        UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40.0)];
        search.placeholder = @"搜索单词";
        search.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        [headView addSubview:search];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 40, WIDTH, 19.9)];
        [sectionLabel setText:[_sectionNameArr[section] uppercaseString]];
        [sectionLabel setTextColor:[UIColor lightGrayColor]];
        sectionLabel.backgroundColor = [UIColor clearColor];
        [sectionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [headView addSubview:sectionLabel];
    }else{
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 19.9)];
        headView.backgroundColor = [UIColor clearColor];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, WIDTH, 19.9)];
        [sectionLabel setText:[_sectionNameArr[section] uppercaseString]];
        sectionLabel.backgroundColor = [UIColor clearColor];
        [sectionLabel setTextColor:[UIColor lightGrayColor]];
        [sectionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [headView addSubview:sectionLabel];
    }
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RemeberWordSingleWordDetailVC *wordDetailVC = [[RemeberWordSingleWordDetailVC alloc] init];
    wordDetailVC.videoURL = [NSURL URLWithString:self.courseUrlArray[indexPath.row]];
    wordDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wordDetailVC animated:YES];
}
@end
