//
//  AboutUsVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "AboutUsVC.h"

@interface AboutUsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *copyrightLabelCollection;
@property (strong,nonatomic) NSArray *dataArray;
@property (copy,nonatomic) NSString *linkUrl;
@property (copy,nonatomic) NSString *typeStr;
@end

@implementation AboutUsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _typeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ios"];
    _tableHeight.constant = [_typeStr isEqualToString:@"0"] ? 88 : 132;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    _appVersionLabel.text = [NSString stringWithFormat:@"%@%@",appName,version];
    _appVersionLabel.textColor = DGRAYCOLOR;
    for (UILabel *item in _copyrightLabelCollection) {
        item.textColor = [UIColor lightGrayColor];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSArray *)dataArray{
    if(!_dataArray){
        if ([_typeStr isEqualToString:@"0"]) {
            _dataArray = @[@"介绍",@"用户协议"];
        }else{
            _dataArray = @[@"使用帮助",@"介绍",@"用户协议"];
        }
    }
    return _dataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [_typeStr isEqualToString:@"0"] ? 2 : 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = D_CELL_BG;
    cell.textLabel.textColor = DGRAYCOLOR;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = D_CELL_SELT;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_typeStr isEqualToString:@"0"]) {
        if(indexPath.row == 0){
            [self performSegueWithIdentifier:@"introduce" sender:self];
        }else{
            [self performSegueWithIdentifier:@"userAgreement" sender:self];
        }
    }else{
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"useHelp" sender:self];
        }else if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"introduce" sender:self];
        }else{
            [self performSegueWithIdentifier:@"userAgreement" sender:self];
        }
    }
}

@end
