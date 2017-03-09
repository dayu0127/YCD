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
#import "WordSearchCell.h"
@interface WordSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YHAlertViewDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic)NSMutableArray *resultArray;
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic) JCAlertView *alertView;
@property (copy,nonatomic) NSString *wordID;
@property (strong,nonatomic) NSArray <NSIndexPath *> *indexPathArray;
@end

@implementation WordSearchVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initResultTableView];
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
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.cornerRadius = 3.0;
    _searchBar.layer.dk_borderColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _searchBar.layer.borderWidth = 1.0f;
    [navBar addSubview:_searchBar];

    [self.view addSubview:navBar];
}
- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initResultTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.bounces = NO;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"WordSearchCell" bundle:nil] forCellReuseIdentifier:@"WordSearchCell"];
}
//#pragma mark 搜索框输入监听
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    [_resultArray removeAllObjects];
//    [_tableView removeFromSuperview];
//    _tableView = nil;
//    for (NSDictionary *dic in self.wordArray) {
//        if ([dic[@"word"] hasPrefix:searchText]) {
//            [_resultArray addObject:dic];
//        }
//    }
//}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (![searchBar.text isEqualToString:@""]) {
        [_resultArray removeAllObjects];
        NSDictionary *dic = @{@"keyWord":searchBar.text,@"userID":[YHSingleton shareSingleton].userInfo.userID};
        [YHWebRequest YHWebRequestForPOST:SEARCHWORD parameters:dic success:^(id  _Nonnull json) {
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                _resultArray = [NSMutableArray arrayWithArray:json[@"data"]];
                [_tableView reloadData];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"数据异常"];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud showWithMessage:@"数据请求失败"];
        }];
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
    WordSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordSearchCell" forIndexPath:indexPath];
    [cell addModelWithDic:_resultArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_resultArray[indexPath.row][@"payType"] integerValue] == 0) {
        //单个单词订阅
        NSDictionary *usrDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        UserInfo *userInfo = [UserInfo yy_modelWithDictionary:usrDic];
        if ([userInfo.freeCount integerValue] == 0) {
            [YHHud showWithMessage:@"免费次数已用完，请前去订阅本学期所有单词"];
        }else{
            _wordID = _resultArray[indexPath.row][@"wordID"];
            _indexPathArray = @[indexPath];
            YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 255, 155) title:@"确认订阅"  message:[NSString stringWithFormat:@"您还有%@次免费订阅的额度，确定使用吗？",userInfo.freeCount]];
            alertView.delegate = self;
            _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
            [_alertView show];
        }
    }else{
        RememberWordSingleWordDetailVC *wordDetailVC = [[RememberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        wordDetailVC.word = [Words yy_modelWithJSON:_resultArray[indexPath.row]];
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"wordID":_wordID,@"device_id":DEVICEID};
        [YHWebRequest YHWebRequestForPOST:FREEWORD parameters:dic success:^(NSDictionary *json) {
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                //更新用户单词的免费订阅次数
                [YHSingleton shareSingleton].userInfo.freeCount = [NSString stringWithFormat:@"%@",json[@"freeCount"]];
                [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                //刷新单词结果集
                for (NSInteger i = 0; i<_resultArray.count; i++) {
                    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[_resultArray objectAtIndex:i]];
                    if ([item[@"wordID"] integerValue] == [_wordID integerValue]) {
                        [item setObject:[NSNumber numberWithInt:1] forKey:@"payType"];
                    }
                    [_resultArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:item]];
                }
                //刷新当前cell的数据
                [_tableView reloadRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                [YHHud showWithSuccess:@"订阅成功"];
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"订阅失败"];
            }
        } failure:^(NSError * _Nonnull error) {
            [YHHud showWithMessage:@"数据请求失败"];
        }];
    }
}
@end
