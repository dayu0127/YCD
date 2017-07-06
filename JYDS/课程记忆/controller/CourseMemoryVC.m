//
//  CourseMemoryVC.m
//  JYDS
//
//  Created by liyu on 2017/4/4.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "CourseMemoryVC.h"
#import "CourseMemoryView.h"
#import "CourseMemoryView1.h"
#import "GradeVC.h"
#import "UIButton+ImageTitleSpacing.h"
@interface CourseMemoryVC ()
@property(strong,nonatomic) NSArray *arr;
@property (copy,nonatomic) NSString *grade_type;
@property (copy,nonatomic) NSString *classTypeIndex;
@property (strong,nonatomic) NSArray *sectionList;
@end

@implementation CourseMemoryVC
- (NSArray *)arr{
    if (!_arr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"courselist" ofType:@"plist"];
        _arr = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.phoneNum !=nil) {
        NSString *freeCount =  [YHSingleton shareSingleton].userInfo.freeCount;
        UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你有%@次免费体验机会",freeCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    [YHWebRequest YHWebRequestForPOST:kSectionList parameters:nil success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            _sectionList = [NSDictionary dictionaryWithJsonString:json[@"data"]][@"SectionList"];
        }else{
            NSLog(@"%@",json[@"code"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    CGFloat x,y,c = (WIDTH-44)/3.0;
    for (int row = 0; row<2; row++) {
        y = 107+row*(c+20);
        for (int col=0; col<3; col++) {
            if (col==0) {   x=15;   }else if (col==1){ x=22+c; }else{  x=29+2*c;   }
            UIButton *courseButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, c, c)];
            [courseButton setBackgroundImage:[UIImage imageNamed:@"course_bg"] forState:UIControlStateNormal];
            [courseButton setBackgroundImage:[UIImage imageNamed:@"course_bg"] forState:UIControlStateHighlighted];
            [courseButton setImage:[UIImage imageNamed:self.arr[row*3+col][@"text"]] forState:UIControlStateNormal];
            [courseButton setImage:[UIImage imageNamed:self.arr[row*3+col][@"text"]] forState:UIControlStateHighlighted];
            [courseButton setTitle:self.arr[row*3+col][@"title"] forState:UIControlStateNormal];
            [courseButton setTitleColor:DGRAYCOLOR forState:UIControlStateNormal];
            courseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            courseButton.tag = row*3+col;
            [courseButton layoutButtonWithEdgeInsetsStyle:YHButtonEdgeInsetsStyleTop imageTitleSpace:8.0f];
            [courseButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:courseButton];
        }
    }
}
- (void)itemClick:(UIButton *)sender{
    [self loginInterceptCompletion:^{
        if (sender.tag < 3) {
            if (sender.tag == 0) {
                _classTypeIndex= nil;
                _grade_type = [NSString stringWithFormat:@"%zd",sender.tag+1];
                [self performSegueWithIdentifier:@"toItemDetail" sender:self];
            }else{
                [YHHud showWithMessage:@"课程正在研制中"];
            }
        }else{
            switch (sender.tag) {
                case 3:
                    _classTypeIndex = @"1";
                    break;
                case 4:
                    _classTypeIndex = @"2";
                    break;
                case 5:
                    _classTypeIndex = @"0";
                    break;
                default:
                    break;
            }
            _grade_type = @"1";
            [self performSegueWithIdentifier:@"toItemDetail" sender:self];
        }
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toItemDetail"]) {
        GradeVC *gradeVC = segue.destinationViewController;
        gradeVC.grade_type = _grade_type;
        gradeVC.classTypeIndex = _classTypeIndex;
    }
}
@end
