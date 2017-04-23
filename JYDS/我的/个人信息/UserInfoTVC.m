//
//  UserInfoTVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "UserInfoTVC.h"
#import <UIButton+WebCache.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
@interface UserInfoTVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (strong,nonatomic) UIAlertController *alertVC;
@property (strong,nonatomic) UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong,nonatomic) UIAlertAction *updateAction;
@property (strong,nonatomic) UIImage *oldImage;
@end

@implementation UserInfoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    _headImageButton.layer.masksToBounds = YES;
    _headImageButton.layer.cornerRadius = 45.5f;
    //加载头像昵称性别
    [_headImageButton setImage:_headImage forState:UIControlStateNormal];
    _nickNameLabel.text = [YHSingleton shareSingleton].userInfo.nickName;
    _sexLabel.text = [[YHSingleton shareSingleton].userInfo.genter isEqualToString:@""] ? @"保密" : [YHSingleton shareSingleton].userInfo.genter;
    if ([[YHSingleton shareSingleton].userInfo.genter intValue] == 1) {
        _sexLabel.text = @"男";
    }else if ([[YHSingleton shareSingleton].userInfo.genter intValue] == 2){
        _sexLabel.text = @"女";
    }else{
        _sexLabel.text = @"保密";
    }
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
#pragma mark 头像上传
- (IBAction)headImageClick:(id)sender {
    _alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    UIAlertAction *nvAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [_alertVC addAction:manAction];
    [_alertVC addAction:nvAction];
    [_alertVC addAction:cancel];
    [self presentViewController:_alertVC animated:YES completion:nil];
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
        _alertVC = [UIAlertController alertControllerWithTitle:@"昵称修改" message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSString *oldNickName =_nickNameLabel.text;
        [_alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入昵称";
            textField.text = oldNickName;
        }];
        UITextField *alertText = (UITextField *)_alertVC.textFields[0];
        [alertText addTarget:self action:@selector(nickEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        _updateAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _nickNameLabel.text = alertText.text;
        }];
        //输入框为空的时候禁用默认修改按钮
        if ([[alertText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            _updateAction.enabled = NO;
        }
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
#pragma 保存昵称和性别
- (IBAction)saveClick:(id)sender {
//    {
//        "userID":"**********",      #用户ID
//        "newNickName":"*****",      #用户新昵称（选填字段）
//        "sex":"男"                   #用户性别（选填字段）
//    }
//    NSString *phoneNum = [YHSingleton shareSingleton].userInfo.phoneNum;
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSString *associatedWx = [YHSingleton shareSingleton].userInfo.associatedWx;
//    NSDictionary *jsonDic = @{@"paramStr":@{
//                                      @"phoneNum":phoneNum,      // #用户手机号
//                                      @"token":token,            //   #令牌
//                                      @"associatedWx":associatedWx  // #第三方绑定的uid 唯一标识
//                                      }};
//    [YHWebRequest YHWebRequestForPOST:kBindingWX parameters:jsonDic success:^(NSDictionary *json) {
//        if ([json[@"code"] integerValue] == 200) {
//            [YHHud showWithSuccess:@"绑定成功"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    {
//        "userPhone":"**********",       #用户手机号
//        "newNickName":"*****",      #用户新昵称（选填字段）
//        "sex":"男"                   #用户性别（选填字段）
//    }
    NSString *sex = _sexLabel.text;
    if ([sex isEqualToString:@"男"]) {
        sex = @"1";
    }else if ([sex isEqualToString:@"女"]){
        sex = @"0";
    }else{
        sex = @"2";
    }
    NSDictionary *jsonDic = @{@"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum,    //#用户手机号
                                          @"newNickName":_nickNameLabel.text,         //#用户新昵称（选填字段）
                                          @"sex":sex};     //#用户性别（选填字段）
    [YHWebRequest YHWebRequestForPOST:kNicknameSex parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            [_delegate updateNickName:_nickNameLabel.text];
            [YHHud showWithSuccess:@"修改成功"];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark UIImagePickerController回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *headImage = info[UIImagePickerControllerEditedImage];
    [_headImageButton setImage:[self compressImage:headImage newWidth:200] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:^{
        //头像上传
        //上传头像图片到服务器
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript",@"text/html",@"text/plain",nil];
        [mgr POST:kUpdateHead parameters:@{@"paramStr":[NSString dictionaryToJson:@{@"userPhone":[YHSingleton shareSingleton].userInfo.phoneNum}]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImagePNGRepresentation(_headImageButton.imageView.image);
            [formData appendPartWithFileData:data name:@"posterFile" fileName:@"headImage.png" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"code"] integerValue] == 200) {
                //把头像图片保存在沙盒中
                NSString *path_sandox = NSHomeDirectory();
                //设置头像图片路径
                NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headImage.png"];
                //把头像图片直接保存到指定的路径（同时应该把头像图片的路径imagePath存起来，下次就可以直接用来取）
                [UIImagePNGRepresentation(_headImageButton.imageView.image) writeToFile:imagePath atomically:YES];
                //更新本地头像url
                //                [YHSingleton shareSingleton].userInfo.headImageUrl = json[@"url"];
                //                [[NSUserDefaults standardUserDefaults] setObject:[[YHSingleton shareSingleton].userInfo yy_modelToJSONObject] forKey:@"userInfo"];
                //更新昵称和性别
                [YHSingleton shareSingleton].userInfo.nickName = _nickNameLabel.text;
                [YHSingleton shareSingleton].userInfo.genter = _sexLabel.text;
                //更新我的页面的头像和昵称
                [_delegate updateHeadImage:_headImageButton.imageView.image];
                [YHHud showWithSuccess:@"修改成功"];
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [YHHud showWithMessage:@"上传失败"];
        }];
    }];
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
