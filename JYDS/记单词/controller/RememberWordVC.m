//
//  RememberWordVC.m
//  JYDS
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordVC.h"
#import "RememberWordItemView.h"
#import "WordSearchVC.h"
#import "RememberWordModuleVC.h"

@interface RememberWordVC ()<UISearchBarDelegate,RememberWordItemViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *wordArray;
@property (nonatomic,strong) NSString *itemTitle;
@property (nonatomic,strong) NSString *classifyID;

@end

@implementation RememberWordVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:@"记单词"];
    _searchBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _searchBar.layer.dk_borderColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _searchBar.layer.borderWidth = 1.0f;
    [self createMainScrollView];
}
#pragma mark 搜索框开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    WordSearchVC *wordSearch = [[WordSearchVC alloc] init];
    wordSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wordSearch animated:YES];
    return NO;
}
#pragma mark 创建主视图
- (void)createMainScrollView{
    [YHHud showWithStatus:@"拼命加载中..."];
    [YHWebRequest YHWebRequestForPOST:COURSE parameters:nil success:^(NSDictionary  *json) {
        [YHHud dismiss];
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            NSArray *dataArray = json[@"data"];
            UIView *lastView = nil;
            _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *dic = dataArray[i];
                RememberWordItemView *itemView = [[RememberWordItemView alloc] initWithNib];
                itemView.translatesAutoresizingMaskIntoConstraints = NO;
                itemView.backgroundColor = [UIColor clearColor];
                itemView.dic = dic;
                itemView.delegate = self;
                [_scrollView addSubview:itemView];
                
                NSMutableArray *layoutArray = [NSMutableArray array];
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                if (i == 0) {
                    [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                    [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                }
                if (lastView != nil) {
                    [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                }
                if (i == dataArray.count - 1) {
                    [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                }
                [NSLayoutConstraint activateConstraints:layoutArray];
                lastView = itemView;
            }
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        [YHHud showWithMessage:@"数据请求失败"];
    }];
}
#pragma mark itemView的点击事件
- (void)itemClickWithClassifyID:(NSInteger)classifyID title:(NSString *)title{
    _itemTitle = title;
    _classifyID = [NSString stringWithFormat:@"%zd",classifyID];
    [self performSegueWithIdentifier:@"toItemDetail" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toItemDetail"]) {
        RememberWordModuleVC *itemVC = segue.destinationViewController;
        itemVC.navTitle = _itemTitle;
        itemVC.classifyID = _classifyID;
        itemVC.hidesBottomBarWhenPushed = YES;
    }
}
@end
