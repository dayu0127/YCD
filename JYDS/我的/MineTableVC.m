//
//  MineTableVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MineTableVC.h"

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _studyBean.dk_textColorPicker = DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED);
    _costStudyBean.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    for (UILabel *item in _titileCollectionLabel) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITableViewCell *item in _tableViewCellCollection) {
        item.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    }
    _studyCodeLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],RED);
    _payButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    //从沙盒取出头像图片
    NSString *path_sandox = NSHomeDirectory();
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        NSData *picData = [NSData dataWithContentsOfFile:imagePath];
        _headImageView.image = [UIImage imageWithData:picData];
    }
    //从用户配置中获取昵称,手机号,学习豆和已消耗学习豆
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    _nickNameLabel.text = userInfo[@"nickName"];
    _phoneNumLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    _studyBean.text = [NSString stringWithFormat:@"%@",userInfo[@"studyBean"]];
    _costStudyBean.text = [NSString stringWithFormat:@"%@",userInfo[@"costStudyBean"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName:) name:@"updateNickName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneNum:) name:@"updatePhoneNum" object:nil];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
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
