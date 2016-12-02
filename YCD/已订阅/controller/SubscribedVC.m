//
//  SubscribedVC.m
//  YCD
//
//  Created by dayu on 2016/11/25.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SubscribedVC.h"
#import "RemeberWordSingleWordDetailVC.h"
@interface SubscribedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
- (IBAction)videoClick:(UIButton *)sender;
- (IBAction)wordClick:(UIButton *)sender;
@property (nonatomic,strong) UITableView *wordTableView;
@property (nonatomic,strong) NSMutableArray *wordArray;
@property (nonatomic,strong) NSMutableArray *sectionNameArr;
@property (nonatomic,strong) NSMutableArray *nameArr;
- (IBAction)btnClick1:(UIButton *)sender;

- (IBAction)btnCllick2:(UIButton *)sender;
@end

@implementation SubscribedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
#pragma mark 懒加载字母数组
- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        NSArray *arr = @[@"about",@"because",@"code",@"discover",@"dispath",@"ever",@"forget",@"give",@"hour",@"italic",@"jump",@"keep",@"littl",@"mark",@"notification",@"open",@"present",@"queue",@"rules",@"storyboard",@"touch",@"underline",@"video",@"what",@"xerox",@"year",@"zero",@"red",@"prama",@"navigation",@"application",@"will",@"you",@"do",@"to",@"use",@"view",@"collection",@"pass",@"the",@"object",@"new",@"segue",@"often",@"set",@"remove",@"nil",@"get"];
        _wordArray = [NSMutableArray arrayWithArray:arr];
    }
    return _wordArray;
}

- (IBAction)videoClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.leftLineView.backgroundColor = [UIColor orangeColor];
    [self.wordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightLineView.backgroundColor = [UIColor clearColor];
    self.bgView.alpha = 1;
    [self.wordTableView removeFromSuperview];
    self.wordTableView = nil;
}

- (IBAction)wordClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.rightLineView.backgroundColor = [UIColor orangeColor];
    [self.videoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftLineView.backgroundColor = [UIColor clearColor];
    self.bgView.alpha = 0;
    self.wordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, WIDTH, HEIGHT-159) style:UITableViewStyleGrouped];
    self.wordTableView.delegate = self;
    self.wordTableView.dataSource = self;
    self.wordTableView.rowHeight = WORD_ROWHEIGHT;
    [self.wordTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [self wordSearch];
    [self.view addSubview:self.wordTableView];
}
#pragma mark 侧边单词检索
- (void)wordSearch{
    //tableView右侧索引栏的字体颜色和背景色
    self.wordTableView.sectionIndexColor = [UIColor darkGrayColor];
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
    cell.textLabel.text = _nameArr[indexPath.section][indexPath.row];
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
        UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40.0)];
        search.placeholder = @"搜索单词";
        [headView addSubview:search];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 40, WIDTH, 19.9)];
        [sectionLabel setText:[_sectionNameArr[section] uppercaseString]];
        [sectionLabel setTextColor:[UIColor lightGrayColor]];
        [sectionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [headView addSubview:sectionLabel];
    }else{
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 19.9)];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, WIDTH, 19.9)];
        [sectionLabel setText:[_sectionNameArr[section] uppercaseString]];
        [sectionLabel setTextColor:[UIColor lightGrayColor]];
        [sectionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [headView addSubview:sectionLabel];
    }
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RemeberWordSingleWordDetailVC *wordDetailVC = [[RemeberWordSingleWordDetailVC alloc] init];
    wordDetailVC.hidesBottomBarWhenPushed = YES;
    wordDetailVC.title = @"单词记忆法";
    [self.navigationController pushViewController:wordDetailVC animated:YES];
}
- (IBAction)btnClick1:(UIButton *)sender {
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)btnCllick2:(UIButton *)sender {
    self.tabBarController.selectedIndex = 1;
}
@end
