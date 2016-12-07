//
//  RememberWordVC.m
//  YCD
//
//  Created by dayu on 2016/11/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordVC.h"
#import "RememberWordSectionView.h"
#import "RememberWordItemView.h"
#import "WordSearchVC.h"
@interface RememberWordVC ()<UISearchBarDelegate,RememberWordItemViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic)NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation RememberWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainScrollView];
//    _scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@{@"name":@"小学",@"detail":@[@"四年级上学期【人教版】",@"四年级上学期【人教版】",@"四年级上学期【沪教版】",@"四年级上学期【沪教版】"]},
                       @{@"name":@"初中",@"detail":@[@"初一上学期【人教版】",@"初一上学期【人教版】",@"初一上学期【沪教版】",@"初一上学期【沪教版】"]},
                       @{@"name":@"高中",@"detail":@[@"高一上学期【人教版】",@"高一上学期【人教版】",@"高一上学期【沪教版】",@"高一上学期【沪教版】",@"2016年全国卷高考单词",@"2016年全国卷高考预测",@"2016年全国卷高考预测"]},
                       @{@"name":@"大学",@"detail":@[@"英语四级考试",@"英语四级考试"]},
                       @{@"name":@"职业资格考试",@"detail":@[@"职业医师资格考试",@"建筑师职业资格考试"]}
                       ];
    }
    return _dataArray;
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
    //    CGFloat height = 0;
    //    for (NSInteger i =0; i<self.dataArray.count; i++) {
    //        NSArray *detailArr = self.dataArray[i][@"detail"];
    //        height =  height + [self getHeightFromArray:detailArr];
    //    }
    //    UIScrollView *mainScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, WIDTH, HEIGHT-152)];
    //    mainScrolView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    mainScrolView.contentSize = CGSizeMake(WIDTH, height+5);
    //    CGFloat maxY = 0;
    //    for (NSInteger i = 0; i < self.dataArray.count; i++) {
    //        CGFloat detail_height = [self getHeightFromArray:self.dataArray[i][@"detail"]];
    //        NSDictionary *detailDic = self.dataArray[i];
    //        if (maxY == 0) {
    //            RememberWordSectionView *sectionView = [[RememberWordSectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, detail_height) detailDic:detailDic];
    //            [mainScrolView addSubview:sectionView];
    //            maxY = CGRectGetMaxY(sectionView.frame);
    //        }else{
    //            RememberWordSectionView *sectionView = [[RememberWordSectionView alloc] initWithFrame:CGRectMake(0, maxY, WIDTH, detail_height) detailDic:detailDic];
    //            [mainScrolView addSubview:sectionView];
    //            maxY = CGRectGetMaxY(sectionView.frame);
    //        }
    //    }
    //    [self.view addSubview:mainScrolView];
    UIView *lastView = nil;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    for (int i = 0; i < self.dataArray.count; i++) {
        
        NSDictionary *dic = self.dataArray[i];
        RememberWordItemView *itemView = [[RememberWordItemView alloc] initWithNib];
        itemView.translatesAutoresizingMaskIntoConstraints = NO;
        itemView.backgroundColor = [UIColor clearColor];
        itemView.tag = i;
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
        if (i == self.dataArray.count - 1) {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        }
        [NSLayoutConstraint activateConstraints:layoutArray];
        lastView = itemView;
        
    }
    
}
//#pragma mark 根据detailArray获取detailView的height
//- (CGFloat)getHeightFromArray:(NSArray *)array{
//    NSInteger item_row = array.count%2==0 ? array.count/2 : array.count/2+1;
//    return TITLE_HEIGHT+item_row*ITEM_HEIGHT+(item_row-1)*5;
//}
#pragma mark itemView的点击事件
- (void)itemClickTitleIndex:(NSInteger)titleIndex itemIndex:(NSInteger)itemIndex{
    NSLog(@"%ld-%ld",titleIndex,itemIndex);
    [self performSegueWithIdentifier:@"toDetail" sender:self];
}
@end
