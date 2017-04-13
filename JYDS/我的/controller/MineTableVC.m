//
//  MineTableVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MineTableVC.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "MJChiBaoZiHeader.h"
//#import "PayVC.h"
@interface MineTableVC ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titileCollectionLabel;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *tableViewCellCollection;
@property (weak, nonatomic) IBOutlet UILabel *studyBean;
@property (weak, nonatomic) IBOutlet UILabel *costStudyBean;
@property (weak, nonatomic) IBOutlet UILabel *banner;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (strong,nonatomic) MJRefreshNormalHeader *header;

@end
@implementation MineTableVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStudyBean) name:@"updateStudyBean" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCostBean) name:@"updateCostBean" object:nil];
}
#pragma mark 更新剩余学习豆
- (void)updateStudyBean{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    UserInfo *model = [UserInfo yy_modelWithDictionary:userDic];
    _studyBean.text = model.studyBean;
}
#pragma mark 更新消费学习豆
- (void)updateCostBean{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    UserInfo *model = [UserInfo yy_modelWithDictionary:userDic];
    _costStudyBean.text = model.costStudyBean;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    //从用户配置中获取用户信息
    [self userConfiguration];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName:) name:@"updateNickName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayMode) name:@"dayMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightMode) name:@"nightMode" object:nil];
    //下拉刷新
//    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"device_id":DEVICEID} success:^(NSDictionary *json) {
//            [self.tableView.mj_header endRefreshing];
//            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//                [self returnToLogin];
//            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                _studyBean.text = [NSString stringWithFormat:@"%@",json[@"data"][@"restBean"]];
//                _costStudyBean.text = [NSString stringWithFormat:@"%@",json[@"data"][@"consumeBean"]];
//                // 拿到当前的下拉刷新控件，结束刷新状态
//            }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                [YHHud showWithMessage:@"服务器错误"];
//            }else{
//                [YHHud showWithMessage:@"数据异常"];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            NSLog(@"111111111111");
//            [self.tableView.mj_header endRefreshing];
//            [YHHud showWithMessage:@"数据请求失败"];
//        }];
//    }];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    _header.automaticallyChangeAlpha = YES;
//    // 隐藏时间
//    _header.lastUpdatedTimeLabel.hidden = YES;
//    // 设置菊花样式
//    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
//        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    }else{
//        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    }
//    // 设置header
//    self.tableView.mj_header = _header;
}
- (void)dayMode{
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}
- (void)nightMode{
    _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}
- (void)nightModeConfiguration{
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _studyBean.dk_textColorPicker = DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED);
    _costStudyBean.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    for (UILabel *item in _titileCollectionLabel) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITableViewCell *item in _tableViewCellCollection) {
        item.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
        item.selectedBackgroundView = [[UIView alloc]initWithFrame:item.frame];
        item.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
    }
    _payButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)userConfiguration{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    UserInfo *model = [UserInfo yy_modelWithDictionary:userDic];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"headImage"]];
    _nickNameLabel.text = model.nickName;
    _studyBean.text = model.studyBean;
    _costStudyBean.text = model.costStudyBean;
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ios"] isEqualToString:@"0"]) {
        if (indexPath.row == 1) {
            return 0.00000001;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)updateHeadImage:(NSNotification *)sender{
    UIImage *headImage = sender.userInfo[@"headImage"];
    _headImageView.image = headImage;
}
- (void)updateNickName:(NSNotification *)sender{
    NSString *str = sender.userInfo[@"nickName"];
    _nickNameLabel.text = str;
}

//- (IBAction)pushToPayVC:(UIButton *)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PayVC *payVc = [sb instantiateViewControllerWithIdentifier:@"pay"];
//    payVc.balance = _studyBean.text;
//    [self.navigationController pushViewController:payVc animated:YES];
//}
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
@end
