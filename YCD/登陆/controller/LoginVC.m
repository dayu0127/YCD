//
//  LoginVC.m
//  YCD
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "LoginVC.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "YHWebRequest.h"
@interface LoginVC ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineCollection;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],N_BG,RED);
    for (UITextField *item in _textFieldCollection) {
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UIView *line in _lineCollection) {
        line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    }
    _loginButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
    for (UIButton *item in _buttonCollection) {
        [item dk_setTitleColorPicker:DKColorPickerWithColors(D_BLUE,[UIColor whiteColor],RED) forState:UIControlStateNormal];
    }
}
- (IBAction)loginButtonClick:(UIButton *)sender {
//    UITextField *textField = [_textFieldCollection objectAtIndex:0];
//    UITextView *textField1 = [_textFieldCollection objectAtIndex:1];
//    NSString *userName = textField.text;
//    NSString *password = textField1.text;
//    if ([userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
//        NSLog(@"您还没输入手机号和密码呢^_^");
//    }else{
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",password,@"password",nil];
//        [YHWebRequest YHWebRequestForPOST:LOGIN parameters:dic success:^(id  _Nonnull json) {
////                    NSLog(@"%@",json);
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"%@",dic);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"网络异常 - T_T%@", error);
//        }];
//    }

//    if (![textField.text isEqualToString:@""]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
        [app.window setRootViewController:rootTBC];
        [app.window makeKeyWindow];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
//    }
}
@end
