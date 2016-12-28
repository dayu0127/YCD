//
//  PayDetailVC.m
//  YCD
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PayDetailVC.h"
#import "PayDetailCell.h"
@interface PayDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *payDetailArray;

@end

@implementation PayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _bgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    UILabel *label = [_labelCollection objectAtIndex:2];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), WIDTH, HEIGHT-CGRectGetMaxY(label.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.rowHeight = 64;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"PayDetailCell" bundle:nil] forCellReuseIdentifier:@"PayDetailCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
