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
@interface LoginVC ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonClick:(UIButton *)sender;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UITextField *item in _textFieldCollection) {
        [item setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        item.dk_tintColorPicker = DKColorPickerWithKey(TINT);
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    [_loginButton dk_setTitleColorPicker:DKColorPickerWithRGB(0xffffff,0x000000,0xff0000) forState:UIControlStateNormal];
}
- (IBAction)loginButtonClick:(UIButton *)sender {
    UITextField *textField = [_textFieldCollection objectAtIndex:0];
    if (![textField.text isEqualToString:@""]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        RootTabBarController *rootTBC = [sb instantiateViewControllerWithIdentifier:@"root"];
        [app.window setRootViewController:rootTBC];
        [app.window makeKeyWindow];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
    }
}
@end
