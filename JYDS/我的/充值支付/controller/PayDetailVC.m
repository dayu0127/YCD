//
//  PayDetailVC.m
//  JYDS
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PayDetailVC.h"
#import "PayDetailCell.h"

@interface PayDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong,nonatomic) NSArray *payDetailArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *payBean;

@end

@implementation PayDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _bgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":userInfo[@"userID"]} success:^(id  _Nonnull json) {
        _payBean.text = [NSString stringWithFormat:@"%@元",json[@"data"][@"rechargeBean"]];
    }];
    [YHWebRequest YHWebRequestForPOST:PAYDETAIL parameters:@{@"userID":userInfo[@"userID"]} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _dataArray = json[@"data"];
            [_tableView registerNib:[UINib nibWithNibName:@"PayDetailCell" bundle:nil] forCellReuseIdentifier:@"PayDetailCell"];
            [_tableView reloadData];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayDetailCell" forIndexPath:indexPath];
    cell.payType.text = [NSString stringWithFormat:@"%@支付",_dataArray[indexPath.row][@"rechargeType"]];
    cell.payDate.text = _dataArray[indexPath.row][@"rechargeTime"];
    cell.payMoney.text = [NSString stringWithFormat:@"%@元", _dataArray[indexPath.row][@"rechargeMoney"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
