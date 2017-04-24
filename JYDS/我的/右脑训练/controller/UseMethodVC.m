//
//  UseMethodVC.m
//  JYDS
//
//  Created by liyu on 2017/4/21.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "UseMethodVC.h"

@interface UseMethodVC ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end

@implementation UseMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentTextView.text = @"想不想像《最强大脑》里的选手一样拥有过目不忘的本领，甚至连毫无规律的数字也能轻松记忆？这其实很简单，只要使用编码法就可以了。\n\n具体步骤如下：\n\n1、点击“编码表”，仔细观察记忆101个数字及其对应的编码图片。\n\n2、记下之后返回至“开始练习”，选择练习题等级，建议从难度系数最低的60秒开始测试。\n\n3、每出现一个数字，你的脑海里要想起对应的图片。如果想不起来，就点击“不记得”。\n\n4、测试结束后，练习结果会显示你想不起来的数字和图片，让你进行再次记忆。如果全部记住，那么恭喜你，可以继续挑战更高一级难度的测试了。\n\n多练习几次，记忆电话号码、各种纪念日，甚至银行卡号就手到擒来了。也锻炼了你的右脑，为你记忆英语单词、古诗词等打下了基础。";
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
