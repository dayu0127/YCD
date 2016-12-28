//
//  RememberWordVC.m
//  YCD
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordVC.h"
#import "RememberWordItemView.h"
#import "WordSearchVC.h"
#import "RememberWordItemVC.h"
@interface RememberWordVC ()<UISearchBarDelegate,RememberWordItemViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *courseVideoArray;
@property (nonatomic,strong) NSString *itemTitle;
@property (nonatomic,strong) NSString *classifyID;

@end

@implementation RememberWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.dk_barTintColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
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
    [YHWebRequest YHWebRequestForPOST:COURSE parameters:nil success:^(NSDictionary  *json) {
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
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络异常 - T_T%@", error);
    }];
}
#pragma mark itemView的点击事件
- (void)itemClickWithClassifyID:(NSInteger)classifyID title:(NSString *)title{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSDictionary *dic = @{@"userID":userInfo[@"userID"],@"classifyID":[NSString stringWithFormat:@"%zd",classifyID]};
    [YHWebRequest YHWebRequestForPOST:COURSEVIDEO parameters:dic success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _itemTitle = title;
            _courseVideoArray = json[@"data"];
            _classifyID = [NSString stringWithFormat:@"%zd",classifyID];
            [self performSegueWithIdentifier:@"toItemDetail" sender:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"网络异常 - T_T%@", error);
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toItemDetail"]) {
        RememberWordItemVC *itemVC = segue.destinationViewController;
        itemVC.title = _itemTitle;
        itemVC.courseVideoArray = _courseVideoArray;
        itemVC.classifyID = _classifyID;
        itemVC.hidesBottomBarWhenPushed = YES;
    }
}
@end
