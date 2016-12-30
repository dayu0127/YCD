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
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *copyrightLabelCollection;
@property (strong,nonatomic) NSArray *dataArray;
@end

@implementation AboutUsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    _appVersionLabel.text = [NSString stringWithFormat:@"%@%@.%@",appName,version,build];
    _appVersionLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    for (UILabel *item in _copyrightLabelCollection) {
        item.dk_textColorPicker = DKColorPickerWithColors([UIColor lightGrayColor],[UIColor groupTableViewBackgroundColor],[UIColor redColor]);
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}
- (NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = @[@"使用帮助",@"介绍",@"用户协议"];
    }
    return _dataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"useHelp" sender:self];
    }else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"introduce" sender:self];
    }else{
        [self performSegueWithIdentifier:@"userAgreement" sender:self];
    }
}
@end
