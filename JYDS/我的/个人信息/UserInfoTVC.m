//
//  UserInfoTVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "UserInfoTVC.h"

@interface UserInfoTVC ()
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (strong,nonatomic) UIAlertController *alertVC;
@property (strong,nonatomic) UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong,nonatomic) UIAlertAction *updateAction;
@end

@implementation UserInfoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    _headImageButton.layer.masksToBounds = YES;
    _headImageButton.layer.cornerRadius = 45.5f;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
- (void)nickEditingChanged:(UITextField *)sender{
    NSString *resultStr = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([resultStr isEqualToString:@""]) {
        _updateAction.enabled = NO;
    }else{
        _updateAction.enabled = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        _alertVC = [UIAlertController alertControllerWithTitle:@"昵称修改" message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
        //昵称修改输入框
        _nickNameText = [UITextField new];
        _nickNameText.borderStyle = UITextBorderStyleRoundedRect;
        _nickNameText.text = _nickNameLabel.text;
        [_nickNameText addTarget:self action:@selector(nickEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [_alertVC.view addSubview:_nickNameText];
        [_nickNameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertVC.view).offset(50);
            make.centerX.mas_equalTo(_alertVC.view.mas_centerX);
            make.width.mas_equalTo(@250);
            make.height.mas_equalTo(@38);
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        _updateAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _nickNameLabel.text = _nickNameText.text;
        }];
        [_alertVC addAction:cancel];
        [_alertVC addAction:_updateAction];
        [self presentViewController:_alertVC animated:YES completion:nil];
    }else if (indexPath.row == 2) {
        _alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sexLabel.text = @"男";
        }];
        UIAlertAction *nvAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sexLabel.text = @"女";
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _sexLabel.text = @"保密";
        }];
        [_alertVC addAction:manAction];
        [_alertVC addAction:nvAction];
        [_alertVC addAction:cancel];
        [self presentViewController:_alertVC animated:YES completion:nil];
    }
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
