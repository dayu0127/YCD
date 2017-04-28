//
//  HelpFeedbackVC.m
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "HelpFeedbackVC.h"

@interface HelpFeedbackVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sureButton;
@property (strong, nonatomic) UITextView *textView;
@property (strong,nonatomic) UILabel *promptLabel;

@end
@implementation HelpFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, WIDTH-20, 200)];
    _textView.font = [UIFont systemFontOfSize:13.0f];
    _textView.delegate = self;
    _textView.layer.borderWidth = 1;
    _textView.textColor = DGRAYCOLOR;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 6.0f;
    [self.view addSubview:_textView];
    [self addPromptContent];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addPromptContent{
    CGFloat y = WIDTH>375 ? 0 : 5;
    NSInteger line = WIDTH>375 ? 1 : 2;
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y, WIDTH-40, 35)];
    _promptLabel.text = @"如果您对记忆大师有什么意见或建议，请在这里告诉我们";
    _promptLabel.numberOfLines = line;
    _promptLabel.textColor = [UIColor lightGrayColor];
    _promptLabel.font = [UIFont systemFontOfSize:14.0f];
    [_textView addSubview:_promptLabel];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        [_promptLabel removeFromSuperview];
        _promptLabel = nil;
    }else{
        [self addPromptContent];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (IBAction)submitClick:(id)sender {
    _textView.text = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([_textView.text isEqualToString:@""]) {
        _promptLabel.textColor = ORANGERED;
    }else{
//        {
//            "userPhone":"******"    #用户手机号
//            "token":"****"          #登陆凭证
//            "content"："**"          #用户反馈内容
//        }
        NSDictionary *jsonDic = @{@"userPhone":self.phoneNum,  //  #用户手机号
                                              @"token":self.token,      //    #登陆凭证
                                              @"content":_textView.text};      //    #用户反馈内容
        [YHWebRequest YHWebRequestForPOST:kFedBack parameters:jsonDic success:^(NSDictionary *json) {
            if ([json[@"code"] integerValue] == 200) {
                _textView.text = @"";
                [YHHud showWithSuccess:@"提交成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                NSLog(@"%@",json[@"code"]);
                [YHHud showWithMessage:json[@"message"]];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender {
    if ([_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        _promptLabel.textColor = [UIColor redColor];
    }else{
//        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"content":_textView.text,@"device_id":DEVICEID};
//        [YHWebRequest YHWebRequestForPOST:FEEDBACK parameters:dic success:^(NSDictionary *json) {
//            if ([json[@"code"] isEqualToString:@"NOLOGIN"]) {
//                [self returnToLogin];
//            }else if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
//                [YHHud showWithSuccess:@"提交成功"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//            }else if([json[@"code"] isEqualToString:@"ERROR"]){
//                [YHHud showWithMessage:@"服务器错误"];
//            }else{
//                [YHHud showWithMessage:@"提交失败"];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            [YHHud showWithMessage:@"数据请求失败"];
//        }];
    }
}
@end
