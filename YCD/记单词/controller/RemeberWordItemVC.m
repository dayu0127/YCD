//
//  RemeberWordItemVC.m
//  YCD
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RemeberWordItemVC.h"
#import "RemeberWordVideoCell.h"
#import "RemeberWordSingleWordCell.h"
#import "RemeberWordVideoDetailVC.h"
#import "RemeberWordSingleWordDetailVC.h"
@interface RemeberWordItemVC ()<UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
- (IBAction)videoClick:(UIButton *)sender;
- (IBAction)wordClick:(UIButton *)sender;
@property (assign,nonatomic) NSInteger flagForTable;    //切换视频和单个词语tableView的标记
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *wordArray;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;
- (IBAction)subscriptionClick:(id)sender;
@property (strong,nonatomic) JCAlertView *alertView;
@end

@implementation RemeberWordItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_videoButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_wordButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    _videoButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _wordButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _footerBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _subscriptionLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [self initTableView];
    if (WIDTH<=320) {
        _subscriptionLabel.numberOfLines=2;
    }
}
- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        NSArray *arr = @[@{@"name":@"UNIT1",@"detail":@[@"merge",@"merge"]},
                         @{@"name":@"UNIT2",@"detail":@[@"merge",@"merge",@"merge",@"merge"]},
                         @{@"name":@"UNIT3",@"detail":@[@"merge",@"merge",@"merge"]},
                         @{@"name":@"UNIT4",@"detail":@[@"merge",@"merge",@"merge",@"merge"]}];
        _wordArray = [NSMutableArray arrayWithArray:arr];
    }
    return _wordArray;
}
- (IBAction)videoClick:(UIButton *)sender{
    sender.selected = YES;
    _wordButton.selected = NO;
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _flagForTable = 0;
    [self initTableView];
    self.subscriptionLabel.text = @"一次订阅所有四年级上半年视频教程,仅需2000学习豆!";
}
- (IBAction)wordClick:(UIButton *)sender{
    sender.selected = YES;
    _videoButton.selected = NO;
    _rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _flagForTable = 1;
    [self initTableView];
    self.subscriptionLabel.text = @"一次订阅所有四年级上半年所有单词,仅需2000学习豆!";
}
#pragma mark 初始化底部TableView
- (void)initTableView{
    if (_tableView != nil) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 116, WIDTH, HEIGHT-160) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    if (_flagForTable == 0) {
        [_tableView registerNib:[UINib nibWithNibName:@"RemeberWordVideoCell" bundle:nil] forCellReuseIdentifier:@"RemeberWordVideoCell"];
    }else{
        [_tableView registerNib:[UINib nibWithNibName:@"RemeberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RemeberWordSingleWordCell"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _flagForTable == 0 ? 1 : self.wordArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.wordArray[section][@"detail"];
    return _flagForTable == 0 ? 2 : arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _flagForTable == 0 ? 10 : 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _flagForTable == 0 ? 80 : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = nil;
    if (_flagForTable == 1) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
//        titleLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor groupTableViewBackgroundColor],[UIColor darkGrayColor],[UIColor redColor]);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.text = _wordArray[section][@"name"];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return titleLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flagForTable == 0) {
        RemeberWordVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemeberWordVideoCell" forIndexPath:indexPath];
        return cell;
    }else{
        RemeberWordSingleWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemeberWordSingleWordCell" forIndexPath:indexPath];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flagForTable == 0) {
//        RemeberWordVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        RemeberWordVideoDetailVC *videoDetailVC = [[RemeberWordVideoDetailVC alloc] init];
        videoDetailVC.hidesBottomBarWhenPushed = YES;
        videoDetailVC.title = @"第一节课";
        [self.navigationController pushViewController:videoDetailVC animated:YES];
    }else{
        RemeberWordSingleWordDetailVC *wordDetailVC = [[RemeberWordSingleWordDetailVC alloc] init];
        wordDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wordDetailVC animated:YES];
    }
}
- (IBAction)subscriptionClick:(id)sender {
    NSString *str = _flagForTable == 0 ? @"视频课程" : @"单词";
    NSString *message = [NSString stringWithFormat:@"如果确定，将一次订阅当前所有%@",str];
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:message];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确认订阅");
    }
    [_alertView dismissWithCompletion:nil];
}
@end
