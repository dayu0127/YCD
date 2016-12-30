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
    }
    //从沙盒取出头像图片
    NSString *path_sandox = NSHomeDirectory();
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        NSData *picData = [NSData dataWithContentsOfFile:imagePath];
        _headImageView.image = [UIImage imageWithData:picData];
    }
    //从用户配置中取出手机号码
    _phoneNumLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneNum:) name:@"updatePhoneNum" object:nil];
}
- (void)updateHeadImage:(NSNotification *)sender{
    UIImage *headImage = sender.userInfo[@"headImage"];
    _headImageView.image = headImage;
}
- (void)updatePhoneNum:(NSNotification *)sender{
    NSString *str = sender.userInfo[@"phoneNum"];
    _phoneNumLabel.text = str;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
@end
