//
//  MineTableVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MineTableVC.h"
#import <UIImageView+WebCache.h>

@interface MineTableVC ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titileCollectionLabel;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *tableViewCellCollection;
@property (weak, nonatomic) IBOutlet UILabel *studyBean;
@property (weak, nonatomic) IBOutlet UILabel *costStudyBean;
@property (weak, nonatomic) IBOutlet UILabel *studyCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end
@implementation MineTableVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBean) name:@"updateBean" object:nil];
}
- (void)updateBean{
    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":[YHSingleton shareSingleton].userInfo.userID} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _studyBean.text = [NSString stringWithFormat:@"%@",json[@"data"][@"restBean"]];
            _costStudyBean.text = [NSString stringWithFormat:@"%@",json[@"data"][@"consumeBean"]];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    //从用户配置中获取用户信息
    [self userConfiguration];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName:) name:@"updateNickName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneNum:) name:@"updatePhoneNum" object:nil];
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
    _studyCodeLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],RED);
    _payButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)userConfiguration{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[YHSingleton shareSingleton].userInfo.headImageUrl] placeholderImage:[UIImage imageNamed:@"headImage"]];
    _nickNameLabel.text = [YHSingleton shareSingleton].userInfo.nickName;
    _phoneNumLabel.text = [YHSingleton shareSingleton].userInfo.userName;
    _studyBean.text = [YHSingleton shareSingleton].userInfo.studyBean;
    _costStudyBean.text = [YHSingleton shareSingleton].userInfo.costStudyBean;
    _studyCodeLabel.text = [NSString stringWithFormat:@"互学码:%@",[YHSingleton shareSingleton].userInfo.studyCode];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
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
- (void)updatePhoneNum:(NSNotification *)sender{
    NSString *str = sender.userInfo[@"phoneNum"];
    _phoneNumLabel.text = str;
}
@end
