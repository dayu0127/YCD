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
    [self nightModeConfiguration];
    _payBean.text = [NSString stringWithFormat:@"%@元",[YHSingleton shareSingleton].userInfo.rechargeBean];
    [YHHud showWithStatus:@"拼命加载中..."];
    [YHWebRequest YHWebRequestForPOST:PAYDETAIL parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线提醒" message:@"该账号已在其他设备上登录" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
                [app.window setRootViewController:loginVC];
                [app.window makeKeyWindow];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _dataArray = json[@"data"];
            [_tableView registerNib:[UINib nibWithNibName:@"PayDetailCell" bundle:nil] forCellReuseIdentifier:@"PayDetailCell"];
            [_tableView reloadData];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
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
    cell.payType.text = [NSString stringWithFormat:@"%@支付",_dataArray[indexPath.row][@"rechargeType"]];
    cell.payDate.text = _dataArray[indexPath.row][@"rechargeTime"];
    cell.payMoney.text = [NSString stringWithFormat:@"%@元", _dataArray[indexPath.row][@"rechargeMoney"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
