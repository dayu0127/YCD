//
//  UpdateHeadImageVC.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "UpdateHeadImageVC.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import <UIImageView+WebCache.h>

@interface UpdateHeadImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *photoSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *photographButton;
@property (strong,nonatomic) UIImage *oldImage;
@end

@implementation UpdateHeadImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoSelectButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    _photographButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG1,N_CELL_BG,RED);
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[YHSingleton shareSingleton].userInfo.headImageUrl] placeholderImage:[UIImage imageNamed:@"headImage"]];
}
- (IBAction)finishButtonClick:(UIBarButtonItem *)sender {
    if (![UIImagePNGRepresentation(_oldImage) isEqual:UIImagePNGRepresentation(_headImageView.image)]) {
        //把头像图片保存在沙盒中
        NSString *path_sandox = NSHomeDirectory();
        //设置头像图片路径
        NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
        //把头像图片直接保存到指定的路径（同时应该把头像图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(_headImageView.image) writeToFile:imagePath atomically:YES];
        //上传头像图片到服务器
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript",@"text/html",@"text/plain",nil];
        
        [mgr POST:kUpdateHead parameters:@{@"paramStr":[NSString dictionaryToJson:@{@"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum}]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImagePNGRepresentation(_headImageView.image);
            [formData appendPartWithFileData:data name:@"posterFile" fileName:@"headImage.png" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//                [self returnToLogin];
            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                //通知我的VC更新头像图片
                NSDictionary *dic = [NSDictionary dictionaryWithObject:_headImageView.image forKey:@"headImage"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadImage" object:nil userInfo:dic];
                [YHSingleton shareSingleton].userInfo.headImageUrl = json[@"url"];
                [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                [YHHud showWithSuccess:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [YHHud showWithMessage:@"上传失败"];
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 打开相册
- (IBAction)photoSelectClick:(UIButton *)sender {
    //相册权限(上线开启注释)
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
    //相机权限(上线开启注释)
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
    _headImageView.image = [self compressImage:headImage newWidth:200];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 压缩图片(图片宽度:像素)
- (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end
