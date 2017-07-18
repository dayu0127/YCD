//
//  MineVC.m
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MineVC.h"
#import "TopCell.h"
#import "MineCell.h"
#import "ButtomCell.h"
#import "NoLoginHeaderView.h"
#import "LoggedInHeaderView.h"
#import "UserInfoTVC.h"
#import <UIButton+WebCache.h>
#import "MyPointsVC.h"
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,LoggedInHeaderViewDelegate,ButtomCellDelegate,UserInfoTVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *arr1;
@property (strong,nonatomic) NSArray *arr2;
@property (strong,nonatomic) LoggedInHeaderView *logged;
@property (strong,nonatomic) TopCell *cell;//我的学习豆cell
@property (strong,nonatomic) MineCell *cell1;//我的积分cell
@end

@implementation MineVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    {
//        "userPhone":"*****",        #用户手机号
//        "token":"***************"   #登陆后的token值
//    }
    if(self.phoneNum!=nil&&self.token!=nil){
        NSDictionary *jsonDic  = @{
                @"userPhone":self.phoneNum,    //    #用户手机号
                @"token":self.token  // #登陆后的token值
        };
        [YHWebRequest YHWebRequestForPOST:kGetUser parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                NSDictionary *jsonDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
                _cell.pointsLabel.text = [NSString stringWithFormat:@"%@",jsonDic[@"user"][@"stuBean"]];
                _cell1.pointLabel.text = [NSString stringWithFormat:@"%@",jsonDic[@"user"][@"points"]];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [_tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:nil] forCellReuseIdentifier:@"TopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ButtomCell" bundle:nil] forCellReuseIdentifier:@"ButtomCell"];
    _arr1 = @[@{@"img":@"mine_mysub",@"title":@"我的订阅"},
                  @{@"img":@"mine_collect",@"title":@"我的收藏"},
                  @{@"img":@"mine_invitation",@"title":@"邀请奖励"}];
    _arr2 = @[@{@"img":@"mine_aboutus",@"title":@"关于我们"},
                  @{@"img":@"mine_feedback",@"title":@"意见反馈"}];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == YES) {
        _logged = [[LoggedInHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 187)];
        NSString *headImageUrl = [NSString stringWithFormat:@"%@",[YHSingleton shareSingleton].userInfo.headImg];
        [_logged.headImageButton sd_setImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_headimage"]];
        _logged.delegate = self;
        _logged.nameLabel.text = [YHSingleton shareSingleton].userInfo.nickName;
        _logged.phoneLabel.text = [YHSingleton shareSingleton].userInfo.phoneNum;
        _tableView.tableHeaderView = _logged;
    }else{
        _tableView.tableHeaderView = [[NoLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 187)];
    }
}
//- (void)updateHeadImageAndNickname:(NSNotification *)sender{
//    UIImage *headImage = sender.userInfo[@"headImage"];
//    [_logged.headImageButton setImage:headImage forState:UIControlStateNormal];
//    NSString *str = sender.userInfo[@"nickName"];
//    _logged.nameLabel.text = str;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 3;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0? 0.000001: 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row ==0) {
        return 38;
    }else if (indexPath.section==3&&indexPath.row ==1){
        return 75;
    }else{
        return 41;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)loginClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginNC *loginVC = [sb instantiateViewControllerWithIdentifier:@"login"];
    [app.window setRootViewController:loginVC];
    [app.window makeKeyWindow];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        if (indexPath.row == 0 ) {//学习豆
            _cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
            _cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _cell;
        }else{//积分
            _cell1 = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
            _cell1.img.image = [UIImage imageNamed:@"mine_points"];
            _cell1.tile.text = @"我的积分";
            _cell1.pointLabel.alpha = 1;
            return _cell1;
        }
    }else if (indexPath.section==1){  
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:_arr1[indexPath.row][@"img"]];
        cell.tile.text = _arr1[indexPath.row][@"title"];
        return cell;
    }else if (indexPath.section==2){
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:_arr2[indexPath.row][@"img"]];
        cell.tile.text = _arr2[indexPath.row][@"title"];
        return cell;
    }else{
        if (indexPath.row == 0) {
            MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
            cell.img.image = [UIImage imageNamed:@"mine_setup"];
            cell.tile.text = @"设置";
            return cell;
        }else{
            ButtomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtomCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }
}
- (void)pushToUserInfo{
    if ([self.phoneNum isEqualToString:@""]) {
        [self returnToBingingPhone];
    }else{
        [self performSegueWithIdentifier:@"toUserInfo" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toUserInfo"]) {
        UserInfoTVC *userInfovc = segue.destinationViewController;
        userInfovc.delegate = self;
        userInfovc.headImage = _logged.headImageButton.imageView.image;
    }else if ([segue.identifier isEqualToString:@"toMyPoints"]){
        MyPointsVC *pointVC = segue.destinationViewController;
        pointVC.points = _cell1.pointLabel.text;
    }
}
- (void)updateHeadImage:(UIImage *)img{
    [_logged.headImageButton setImage:img forState:UIControlStateNormal];
}
- (void)updateNickName:(NSString *)str{
    _logged.nameLabel.text = str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (indexPath.section ==0) {
        if (token == nil && userInfo == nil) {
            [self returnToLogin];
        }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
            [self returnToBingingPhone];
        }else{
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"toMyBeans" sender:self];
            }else{
                [self performSegueWithIdentifier:@"toMyPoints" sender:self];
            }
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {//我的订阅
            if (token == nil && userInfo == nil) {
                [self returnToLogin];
            }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
                [self returnToBingingPhone];
            }else{
                [self performSegueWithIdentifier:@"toMySub" sender:self];
            }
        }else if(indexPath.row == 1){//我的收藏
            if (token == nil && userInfo == nil) {
                [self returnToLogin];
            }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
                [self returnToBingingPhone];
            }else{
                [self performSegueWithIdentifier:@"toMyCollect" sender:self];
            }
        }else{//邀请奖励
            if (token == nil && userInfo == nil) {
                [self returnToLogin];
            }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
                [self returnToBingingPhone];
            }else{
                [self performSegueWithIdentifier:@"toInviteRewards" sender:self];
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {//关于我们
            [self performSegueWithIdentifier:@"toAboutUs" sender:self];
        }else{//意见反馈
            if (token == nil && userInfo == nil) {
                [self returnToLogin];
            }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil || userInfo[@"associatedWb"] != nil)) {
                [self returnToBingingPhone];
            }else{
                [self performSegueWithIdentifier:@"toFeedback" sender:self];
            }
        }
    }else if(indexPath.section == 3&&indexPath.row == 0){//设置
        [self performSegueWithIdentifier:@"toSet" sender:self];
    }
}
- (void)telephoneClick{
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
@end
