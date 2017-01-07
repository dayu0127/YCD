//
//  UpdateInfoTableVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "UpdateInfoTableVC.h"
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
    //从沙盒取出头像图片
    NSString *path_sandox = NSHomeDirectory();
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        NSData *picData = [NSData dataWithContentsOfFile:imagePath];
        _headImageView.image = [UIImage imageWithData:picData];
    }
    //从用户配置中取出手机号码和昵称
    _phoneNumLabel.text = [YHSingleton shareSingleton].userInfo.userName;
    _nickNameLabel.text = [YHSingleton shareSingleton].userInfo.nickName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneNum:) name:@"updatePhoneNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName:) name:@"updateNickName" object:nil];
}
- (void)updateHeadImage:(NSNotification *)sender{
    UIImage *headImage = sender.userInfo[@"headImage"];
    _headImageView.image = headImage;
}
- (void)updatePhoneNum:(NSNotification *)sender{
    NSString *str = sender.userInfo[@"phoneNum"];
    _phoneNumLabel.text = str;
}
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
