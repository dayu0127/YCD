//
//  SetVC.m
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SetVC.h"

@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *arr;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-120) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}
- (NSArray *)arr{
    if (!_arr) {
        _arr = @[@"夜间模式",@"清除缓存"];
    }
    return _arr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 44)];
    label.text = self.arr[indexPath.section];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    [cell.contentView addSubview:label];
    if (indexPath.section==0) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake((WIDTH-67), 6.5, 51, 31)];
        [sw addTarget:self action:@selector(openNight:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:sw];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openNight:(UISwitch *)sender{
    if (sender.on == YES) {
        NSLog(@"开启夜间模式");
    }else{
        NSLog(@"关闭夜间模式");
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
