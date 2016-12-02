//
//  PaymentVC.m
//  YCD
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PaymentVC.h"
#import "PaymentCell.h"
@interface PaymentVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *studyDouLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _studyDouLabel.text = [NSString stringWithFormat:@"%ld学习豆，",_money*PAY_PROPORTION];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    NSString *moneyStr = [NSString stringWithFormat:@"%ld元",_money];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [content addAttributes:dic range:NSMakeRange(moneyStr.length-1, 1)];
    _moneyLabel.attributedText = content;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, WIDTH, HEIGHT-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:@"PaymentCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell" forIndexPath:indexPath];
    cell.title.text = indexPath.section == 0 ? @"支付宝支付" : @"微信支付";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"支付宝支付");
    }else{
        NSLog(@"微信支付支付");
    }
}
@end
