//
//  UseMethodVC.m
//  JYDS
//
//  Created by liyu on 2017/4/21.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "UseMethodVC.h"

@interface UseMethodVC ()

@end

@implementation UseMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UILabel *useLabel = [UILabel new];
//    useLabel.text = @"点击“编码表”，仔细观察记忆101个数字和图片，记下之后返回至“开始练习”，选择练习题等级，建议从难度系数最低的60秒开始测试。我们可以看到，画面上圆圈里的数字一直在跳动，出现一个数字，脑海里要能想起对应的图片。如果想不起来，就点击“不记得”。测试结束后，练习结果会将你想不起来的数字和图片呈现出来。如果全部记住，那么恭喜你，可以继续挑战更高一级难度的测试了。";
//    useLabel.textColor = DGRAYCOLOR;
//    useLabel.font = [UIFont systemFontOfSize:15.0f];
//    //设置换行
////    useLabel.lineBreakMode = NSLineBreakByWordWrapping;
////    useLabel.numberOfLines = 0;
//    [self.view addSubview:useLabel];
//    [useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(self.view).offset(6);
//        make.right.equalTo(self.view).offset(-6);
//        make.height.mas_equalTo(@(HEIGHT*0.5));
//    }];
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
