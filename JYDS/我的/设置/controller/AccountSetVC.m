//
//  AccountSetVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "AccountSetVC.h"
#import "SetCell.h"
#import "AccountSetCell.h"
@interface AccountSetVC ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccountSetCell" bundle:nil] forCellReuseIdentifier:@"AccountSetCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
        cell.title1.text = @"手机号码";
        cell.title2.font = [UIFont systemFontOfSize:12.0f];
        cell.title2.text = @"13712345678";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        AccountSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSetCell" forIndexPath:indexPath];
        return cell;
    }else{
        AccountSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSetCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"QQ账号";
        return cell;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
