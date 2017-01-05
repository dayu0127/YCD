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
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender;
@property (strong, nonatomic) UITextView *textView;
@property (strong,nonatomic) UILabel *promptLabel;

@end
@implementation HelpFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(27, 10, WIDTH-54, 200)];
    _textView.font = [UIFont systemFontOfSize:13.0f];
    _textView.delegate = self;
    _textView.layer.borderWidth = 1;
    _textView.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _textView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 8.0f;
    [self.view addSubview:_textView];
    [self addPromptContent];
}
- (void)addPromptContent{
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 14)];
    _promptLabel.text = @"请告诉我们您的建议意见^_^";
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
- (IBAction)sureButtonClick:(UIBarButtonItem *)sender {
    if ([_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        _promptLabel.textColor = [UIColor redColor];
    }else{
        NSDictionary *dic = @{@"userID":[YHSingleton shareSingleton].userInfo.userID,@"content":_textView.text};
        [YHWebRequest YHWebRequestForPOST:FEEDBACK parameters:dic success:^(NSDictionary *json) {
            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                [YHHud showWithSuccess:@"提交成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}
@end
