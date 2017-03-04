//
//  RememberWordModuleVC.m
//  JYDS
//
//  Created by liyu on 2017/3/3.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "RememberWordModuleVC.h"
#import "RememberWordSingleWordCell.h"
#import "RememberWordItemVC.h"
#import "PayVC.h"
@interface RememberWordModuleVC ()<UITableViewDelegate,UITableViewDataSource,YHAlertViewDelegate,RememberWordItemVCDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (assign,nonatomic) BOOL isHiddenNav;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;
@property (strong,nonatomic) NSArray *unitArray;
@property (strong,nonatomic) JCAlertView *alertView;
@property (strong,nonatomic) NSString *subBean;
@end

@implementation RememberWordModuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaBar:self.navTitle];
    self.leftBarButton.hidden = NO;
    [self nightModeConfiguration];
    [YHWebRequest YHWebRequestForPOST:UNITLIST parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _unitArray = json[@"data"];
            _subBean = [NSString stringWithFormat:@"%@",json[@"subBean"]];
            CGFloat h = 0;
            if ([_subBean integerValue] > 0) {
                _subscriptionLabel.text = [NSString stringWithFormat:@"一次性订阅%@的所有单词，仅需%@学习豆",self.navTitle,_subBean];
                h = HEIGHT-108;
            }else{
                _footerBgView.alpha = 0;
                h = HEIGHT - 64;
            }
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, h) style:UITableViewStyleGrouped];
            _tableView.delegate = self;
            _tableView.bounces = NO;
            _tableView.dataSource = self;
            _tableView.separatorInset = UIEdgeInsetsZero;
            _tableView.backgroundColor = [UIColor clearColor];
            [_tableView registerNib:[UINib nibWithNibName:@"RememberWordSingleWordCell" bundle:nil] forCellReuseIdentifier:@"RememberWordSingleWordCell"];
            [self.view addSubview:_tableView];
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    }];
}
- (void)nightModeConfiguration{
    _footerBgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _subscriptionLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _subscriptionButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _unitArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RememberWordSingleWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RememberWordSingleWordCell" forIndexPath:indexPath];
    cell.word.text  = _unitArray[indexPath.row][@"unitName"];
    cell.wordPrice.alpha = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RememberWordItemVC *itemVC = [[RememberWordItemVC alloc] init];
    itemVC.classifyID = _classifyID;
    itemVC.unitID = _unitArray[indexPath.row][@"id"];
    itemVC.navTitle = _unitArray[indexPath.row][@"unitName"];
    itemVC.delegate = self;
    [self.navigationController pushViewController:itemVC animated:YES];
}
- (void)updateSubBean{
    [YHWebRequest YHWebRequestForPOST:UNITLIST parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"classifyID":_classifyID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
            [self returnToLogin];
        }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            if ([_subBean integerValue] > 0) {
                _subscriptionLabel.text = [NSString stringWithFormat:@"一次性订阅%@的所有单词，仅需%@学习豆",self.navTitle,json[@"subBean"]];
            }else{
                _footerBgView.alpha = 0;
            }
        }else if([json[@"code"] isEqualToString:@"ERROR"]){
            [YHHud showWithMessage:@"服务器错误"];
        }else{
            [YHHud showWithMessage:@"数据异常"];
        }
    }];
}
- (void)pushPayVC{
    [YHHud showWithMessage:@"您的学习豆不足，请充值"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isHiddenNav = YES;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PayVC *payVC = [sb instantiateViewControllerWithIdentifier:@"pay"];
        payVC.isHiddenNav = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    });
}
#pragma mark 全部订阅
- (IBAction)subscriptionClick:(UIButton *)sender {
    NSString *message = @"如果确定，将一次订阅当前所有单词";
    YHAlertView *alertView = [[YHAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 155) title:@"· 确认订阅 ·" message:message];
    alertView.delegate = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:alertView dismissWhenTouchedBackground:NO];
    [_alertView show];
}
- (void)buttonClickIndex:(NSInteger)buttonIndex{
    [_alertView dismissWithCompletion:nil];
    if (buttonIndex == 1) {
            //学习豆不足
            if ([_subBean integerValue]>[[YHSingleton shareSingleton].userInfo.studyBean integerValue]) {
                [self pushPayVC];
            }else{
                //学习豆充足
                NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"type":@"words",@"classifyID":_classifyID,@"device_id":DEVICEID};
                [YHWebRequest YHWebRequestForPOST:SUBALL parameters:dic success:^(NSDictionary  *json) {
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
                        _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
                        _footerBgView.alpha = 0;
                        [YHHud showWithSuccess:@"订阅成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCostBean" object:nil];
                    }else if([json[@"code"] isEqualToString:@"ERROR"]){
                        [YHHud showWithMessage:@"服务器错误"];
                    }else{
                        [YHHud showWithMessage:@"订阅失败"];
                    }
                }];
        }
    }
}
- (void)returnToLogin{
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
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHiddenNav == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
@end
