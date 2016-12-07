//
//  UpdateHeadImageVC.m
//  YCD
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "UpdateHeadImageVC.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
@interface UpdateHeadImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButton;
- (IBAction)finishButtonClick:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *photoSelectButton;
- (IBAction)photoSelectClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *photographButton;
- (IBAction)photographClick:(UIButton *)sender;

@end

@implementation UpdateHeadImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _finishButton.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
    //从沙盒中获取头像图片
    NSString *path_sandox = NSHomeDirectory();
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        NSData *picData = [NSData dataWithContentsOfFile:imagePath];
        _headImageView.image = [UIImage imageWithData:picData];
    }
    _photographButton.layer.borderWidth = 1;
    _photographButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_photoSelectButton dk_setTitleColorPicker:DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]) forState:UIControlStateNormal];
    _photographButton.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
}
- (IBAction)finishButtonClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 打开相册
- (IBAction)photoSelectClick:(UIButton *)sender {
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark 打开相机
- (IBAction)photographClick:(UIButton *)sender {
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark UIImagePickerController回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *headImage = info[UIImagePickerControllerEditedImage];
    _headImageView.image = headImage;
    //把头像图片保存在沙盒中
    NSString *path_sandox = NSHomeDirectory();
    //设置头像图片路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
    //把头像图片直接保存到指定的路径（同时应该把头像图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(headImage) writeToFile:imagePath atomically:YES];
    //上传头像图片到服务器(。。。。。。)
    //通知我的VC更新头像图片
    NSDictionary *dic = [NSDictionary dictionaryWithObject:headImage forKey:@"headImage"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadImage" object:self userInfo:dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
