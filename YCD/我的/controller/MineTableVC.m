//
//  MineTableVC.m
//  YCD
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
@property (weak, nonatomic) IBOutlet UILabel *studyDouNum;
@property (weak, nonatomic) IBOutlet UILabel *currentStudyDouNum;
@property (weak, nonatomic) IBOutlet UILabel *studyCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation MineTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _studyDouNum.dk_textColorPicker = DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED);
    _currentStudyDouNum.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    for (UILabel *item in _titileCollectionLabel) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITableViewCell *item in _tableViewCellCollection) {
        item.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    }
    _studyCodeLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],RED);
    _payButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //从沙盒取出头像图片
    NSString *path_sandox = NSHomeDirectory();
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        NSData *picData = [NSData dataWithContentsOfFile:imagePath];
        _headImageView.image = [UIImage imageWithData:picData];
    }
    //从用户配置中获取昵称和手机号
    _nickNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    _phoneNumLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:@"updateHeadImage" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName:) name:@"updateNickName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneNum:) name:@"updatePhoneNum" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 13.0 : 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
