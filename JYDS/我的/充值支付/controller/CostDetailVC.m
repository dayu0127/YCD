//
//  CostDetailVC.m
//  JYDS
//
//  Created by liyu on 2016/12/29.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "CostDetailVC.h"
#import "PayDetailCell.h"

@interface CostDetailVC ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *costBean;

@end

@implementation CostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
        _costBean.text = [NSString stringWithFormat:@"%@个",json[@"data"][@"consumeBean"]];
    }];
    [YHWebRequest YHWebRequestForPOST:COSTDETAIL parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _dataArray = json[@"data"];
            [_tableView registerNib:[UINib nibWithNibName:@"PayDetailCell" bundle:nil] forCellReuseIdentifier:@"PayDetailCell"];
            [_tableView reloadData];
        }
    }];
}
- (void)nightModeConfiguration{
    _bgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayDetailCell" forIndexPath:indexPath];
    cell.payType.text = _dataArray[indexPath.row][@"payType"];
    cell.payDate.text = _dataArray[indexPath.row][@"payTime"];
    cell.payMoney.text = [NSString stringWithFormat:@"%@元", _dataArray[indexPath.row][@"money"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
