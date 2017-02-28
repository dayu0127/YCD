//
//  WordSearchVC.m
//  JYDS
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "WordSearchVC.h"
#import "RememberWordSingleWordDetailVC.h"
#import "Words.h"
@interface WordSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic)NSMutableArray *resultArray;
@property (strong,nonatomic)UITableView *tableView;
@end

@implementation WordSearchVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultArray = [NSMutableArray array];
    [self initNavBar];
}
- (void)initNavBar{
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    navBar.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    
    //返回按钮
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 20, 20, 20);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:leftBarButton];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, WIDTH-40, 44)];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _searchBar.placeholder = @"请搜索单词";
    _searchBar.delegate = self;
    [navBar addSubview:_searchBar];
    
    [self.view addSubview:navBar];
}
- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 搜索框输入监听
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_resultArray removeAllObjects];
    [_tableView removeFromSuperview];
    _tableView = nil;
    for (NSDictionary *dic in self.wordArray) {
        if ([dic[@"word"] hasPrefix:searchText]) {
            [_resultArray addObject:dic];
        }
    }
    if (_resultArray.count>0) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-108) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
}
#pragma mark tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    cell.textLabel.text = _resultArray[indexPath.row][@"word"];
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_resultArray[indexPath.row][@"payType"] integerValue] == 1) {//已经订阅直接跳转
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:_resultArray[indexPath.row]];
        [self.navigationController pushViewController:wordDetailVC animated:YES];
        _searchBar.text = @"";
        [_resultArray removeAllObjects];
        [_tableView removeFromSuperview];
        _tableView = nil;
    }else{
        [YHHud showWithMessage:@"该单词未来订阅，请先订阅"];
    }
}
@end
