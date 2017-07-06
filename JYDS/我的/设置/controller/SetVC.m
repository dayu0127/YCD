//
//  SetVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "SetVC.h"
#import <UIImageView+WebCache.h>
#import "SetCell0.h"
#import "SetCell1.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *arr;
@property (nonatomic,strong) JCAlertView *alertView;

@end
@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell0" bundle:nil] forCellReuseIdentifier:@"SetCell0"];
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell1" bundle:nil] forCellReuseIdentifier:@"SetCell1"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSArray *)arr{
    if (!_arr) {
        _arr = @[@"夜间模式",@"消息通知",@"清除缓存"];
    }
    return _arr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SetCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell0" forIndexPath:indexPath];
        cell.titleLabel0.text = @"账号设置";
        [cell setCellWithString:@""];
        cell.bingingLabel.alpha = 0;
        return cell;
    }else if(indexPath.row == 1){
        SetCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell1" forIndexPath:indexPath];
        return cell;
    }else{
        SetCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell0" forIndexPath:indexPath];
        cell.titleLabel0.text = @"清除缓存";
        [cell setCellWithString:@""];
        cell.bingingLabel.alpha = 0;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.token==nil&&self.phoneNum==nil) {
            [self returnToLogin];
        }else{
            [self performSegueWithIdentifier:@"toAccountSet" sender:self];
        }
    }else if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [YHHud showWithStatus];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        [YHHud dismiss];
        [YHHud showWithSuccess:@"清除成功"];
    }
}
@end
