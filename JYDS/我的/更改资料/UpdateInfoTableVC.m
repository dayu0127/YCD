//
//  UpdateInfoTableVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "UpdateInfoTableVC.h"
#import <UIImageView+WebCache.h>

@interface UpdateInfoTableVC ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *tableViewCellCollection;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *rightLabelCollection;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation UpdateInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
    //从用户配置中取出手机号码，头像和昵称
    NSMutableString *phoneStr = [NSMutableString stringWithString:[YHSingleton shareSingleton].userInfo.userName];
    [phoneStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _phoneNumLabel.text = phoneStr;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[YHSingleton shareSingleton].userInfo.headImageUrl] placeholderImage:[UIImage imageNamed:@"headImage"]];
    _nickNameLabel.text = [YHSingleton shareSingleton].userInfo.nickName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneNum:) name:@"updatePhoneNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName:) name:@"updateNickName" object:nil];
}
- (void)nightModeConfiguration{
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UILabel *item in _rightLabelCollection) {
        item.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    }
    for (UITableViewCell *item in _tableViewCellCollection) {
        item.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
        item.selectedBackgroundView = [[UIView alloc]initWithFrame:item.frame];
        item.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
    }
}
- (void)updateHeadImage:(NSNotification *)sender{
    UIImage *headImage = sender.userInfo[@"headImage"];
    _headImageView.image = headImage;
}
//- (void)updatePhoneNum:(NSNotification *)sender{
//    NSString *str = sender.userInfo[@"phoneNum"];
//    _phoneNumLabel.text = str;
//}
- (void)updateNickName:(NSNotification *)sender{
    NSString *str = sender.userInfo[@"nickName"];
    _nickNameLabel.text = str;
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
