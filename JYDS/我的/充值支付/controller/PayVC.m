//
//  PayVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PayVC.h"
#import "PaymentVC.h"
#import "RememberWordSingleWordCell.h"
#import "OtherAmountCell.h"
@interface PayVC ()<UITableViewDelegate,UITableViewDataSource>

@property (assign,nonatomic) NSInteger money;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (weak, nonatomic) IBOutlet UIButton *contactServiceButton;
@property (weak, nonatomic) IBOutlet UILabel *payBean;

@end

@implementation PayVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _payBean.text = [NSString stringWithFormat:@"%@个",json[@"data"][@"restBean"]];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    }];
    [self nightModeConfiguration];
    CGFloat y = 0;
    if (_isHiddenNav == YES) {
        y = CGRectGetMaxY(_bgView.frame) + 64;
    }else{
        y = CGRectGetMaxY(_bgView.frame);
    }
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIDTH, 35)];
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 35)];
    payLabel.text = @"充值金额";
    payLabel.font = [UIFont systemFontOfSize:15.0f];
    payLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [payView addSubview:payLabel];
    [self.view addSubview:payView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(payView.frame), WIDTH, (PAY_ARRAY.count+1)*44) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
    [tableView registerNib:[UINib nibWithNibName:@"OtherAmountCell" bundle:nil] forCellReuseIdentifier:@"OtherAmountCell"];
}
- (void)nightModeConfiguration{
    _bgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    [_contactServiceButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return PAY_ARRAY.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=PAY_ARRAY.count) {
        RememberWordSingleWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordSingleWordCell" forIndexPath:indexPath];
        cell.word.text = [NSString stringWithFormat:@"%@学习豆",[PAY_ARRAY objectAtIndex:indexPath.row]];
        cell.wordPrice.text = [NSString stringWithFormat:@"%d元",[[PAY_ARRAY objectAtIndex:indexPath.row] intValue]*PAY_PROPORTION];
        return cell;
    }else{
        OtherAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherAmountCell" forIndexPath:indexPath];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _money = [[PAY_ARRAY objectAtIndex:indexPath.row] integerValue]*PAY_PROPORTION;
    [self performSegueWithIdentifier:@"toPayment" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toPayment"]) {
        PaymentVC *paymentVC = segue.destinationViewController;
        paymentVC.money = _money;
    }
}
- (IBAction)contactServiceClick:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *telephone = [UIAlertAction actionWithTitle:@"021-50725551" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"021-50725551"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:telephone];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
@end
