//
//  UpdateNickNameVC.m
//  JYDS
//
//  Created by 李禹 on 2016/12/5.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "UpdateNickNameVC.h"
@interface UpdateNickNameVC ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation UpdateNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nightModeConfiguration];
     [_nickNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)nightModeConfiguration{
    _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _sureButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    _nickNameTextField.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    _nickNameTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
}
- (IBAction)nickNameText:(UITextField *)sender {
    if (sender.text.length > 12) {
        sender.text = [sender.text substringToIndex:12];
    }
}
- (IBAction)sureButtonClick:(UIButton *)sender {
    if (REGEX(NICK_RE, _nickNameTextField.text)==NO) {
        [YHHud showWithMessage:@"只能是数字,字母,下划线和汉字哦"];
    }else{
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"nickName":_nickNameTextField.text,@"device_id":DEVICEID};
        [YHWebRequest YHWebRequestForPOST:UPDNICK parameters:dic success:^(NSDictionary *json) {
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
                [YHHud showWithSuccess:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //更新用户信息
                    [YHSingleton shareSingleton].userInfo.nickName = _nickNameTextField.text;
                    [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:_nickNameTextField.text forKey:@"nickName"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNickName" object:nil userInfo:dic];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if([json[@"code"] isEqualToString:@"ERROR"]){
                [YHHud showWithMessage:@"服务器错误"];
            }else{
                [YHHud showWithMessage:@"修改失败"];
            }
        }];
    }
}
@end
