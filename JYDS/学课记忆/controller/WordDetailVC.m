//
//  WordDetailVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordDetailVC.h"
#import "WordDetailCell.h"
#import "WordImageCell.h"
#import "UIButton+ImageTitleSpacing.h"
@interface WordDetailVC ()<UITableViewDataSource,UITableViewDelegate,WordImageCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *soundMarkButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIImageView *img;
@property (strong,nonatomic) WordImageCell *cell;
@property (strong,nonatomic) UIView *footView;

@end

@implementation WordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_soundMarkButton layoutButtonWithEdgeInsetsStyle:YHButtonEdgeInsetsStyleRight imageTitleSpace:8];
    [_tableView registerNib:[UINib nibWithNibName:@"WordDetailCell" bundle:nil] forCellReuseIdentifier:@"WordDetailCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"WordImageCell" bundle:nil] forCellReuseIdentifier:@"WordImageCell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getFootViewHeight:WIDTH])];//86  140  176
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=2) {
        return 82;
    }else{
        return (WIDTH-80)*(240/295.0)+76;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordDetailCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1){
        WordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordDetailCell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:@"course_lian"];
        return cell;
    }else{
        _cell = [tableView dequeueReusableCellWithIdentifier:@"WordImageCell" forIndexPath:indexPath];
        _cell.delegate = self;
        return _cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    _cell.leftSpace.constant = (offsetY+49)/135*82;
    if (_cell.leftSpace.constant >= 112) {
        [self showBottomUI];
    }else{
        //隐藏底部功能界面
        _cell.line.alpha = 0;
        _cell.showButton.alpha = 0;
        _cell.rwButton.alpha = 0;
        if (_cell.leftSpace.constant<=32) {
            _cell.leftSpace.constant=32;
            //显示跟读/跟写按钮
            _cell.readButton.alpha = 1;
            _cell.writeButton.alpha = 1;
        }
    }
    _cell.btnBottomSpace.constant = _cell.frame.size.height - CGRectGetMaxY(_cell.img.frame) + 6;
}
- (void)showReadAndWrite{
    [_tableView setContentOffset:CGPointMake(0,  136)];
    [self showBottomUI];
}
- (void)showBottomUI{
    _cell.leftSpace.constant = 112;
    //显示底部功能界面
    _cell.line.alpha = 1;
    _cell.showButton.alpha = 1;
    _cell.rwButton.alpha = 1;
    //隐藏跟读/跟写按钮
    _cell.readButton.alpha = 0;
    _cell.writeButton.alpha = 0;
}
- (CGFloat)getFootViewHeight:(CGFloat)width{
    CGFloat h = 0;
    if (width==320) {
        h = 86;
    }else if(width==375){
        h = 140;
    }else if(width==414){
        h = 176;
    }
    return h;
}
#pragma mark 显示跟读
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
