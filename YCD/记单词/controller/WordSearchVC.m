//
//  WordSearchVC.m
//  YCD
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "WordSearchVC.h"
#import "RemeberWordSingleWordDetailVC.h"
@interface WordSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic)NSArray *wordArray;
@property (strong,nonatomic)NSMutableArray *resultArray;
@property (strong,nonatomic)UITableView *tableView;
@end

@implementation WordSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.resultArray = [NSMutableArray array];
    [self initSearchBar];
}

- (NSArray *)wordArray{
    if (!_wordArray) {
       _wordArray = @[@"aa",@"aaa",@"aaaa",@"bb",@"bbb",@"bbbb",@"cc",@"ccc",@"cccc"];
    }
    return _wordArray;
}
- (void)initSearchBar{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-95, 30)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4.0f;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchBar = [[UISearchBar alloc] initWithFrame:bgView.frame];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.placeholder = @"请搜索单词";
    _searchBar.delegate = self;
    [bgView addSubview:_searchBar];
    self.navigationItem.titleView = bgView;
}
#pragma mark 搜索框输入监听
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_resultArray removeAllObjects];
    [_tableView removeFromSuperview];
    _tableView = nil;
    for (NSString *word in self.wordArray) {
        if ([word hasPrefix:searchText]) {
            [_resultArray addObject:word];
        }
    }
    if (_resultArray.count>0) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-108) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.bounces = NO;
        [self.view addSubview:self.tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
}
#pragma mark tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RemeberWordSingleWordDetailVC *wordDetailVC = [[RemeberWordSingleWordDetailVC alloc] init];
    wordDetailVC.hidesBottomBarWhenPushed = YES;
    wordDetailVC.title = @"单词记忆法";
    [self.navigationController pushViewController:wordDetailVC animated:YES];
    _searchBar.text = @"";
    [_resultArray removeAllObjects];
    [_tableView removeFromSuperview];
    _tableView = nil;
}
@end
