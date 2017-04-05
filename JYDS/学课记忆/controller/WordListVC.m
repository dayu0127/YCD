//
//  WordListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordListVC.h"
#import "NotSubCell.h"
#import "SubedCell.h"
@interface WordListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *notSubBtn;
@property (weak, nonatomic) IBOutlet UIButton *subedBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomSpace;
@property (assign,nonatomic) int tableIndex;
@property (weak, nonatomic) IBOutlet UIButton *subAllButton;
@end

@implementation WordListVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"NotSubCell" bundle:nil] forCellReuseIdentifier:@"NotSubCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SubedCell" bundle:nil] forCellReuseIdentifier:@"SubedCell"];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)notSubBtnClick:(UIButton *)sender {
    _tableIndex = 0;
    [_tableView reloadData];
    _subAllButton.alpha = 1;
    _tableViewBottomSpace.constant = 65;
}
- (IBAction)subedBtnClick:(UIButton *)sender {
    _tableIndex = 1;
    [_tableView reloadData];
    _subAllButton.alpha = 0;
    _tableViewBottomSpace.constant = 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableIndex == 0) {
        NotSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotSubCell" forIndexPath:indexPath];
        return cell;
    }else{
        SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toWordDetail" sender:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
@end
