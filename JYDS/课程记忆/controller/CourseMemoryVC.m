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
@interface CourseMemoryVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic) NSArray *arr;
@property (copy,nonatomic) NSString *grade_type;
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
    CGFloat c = WIDTH/3.0;
    _scrollView.contentSize = CGSizeMake(WIDTH, (c+16)*4);
    self.automaticallyAdjustsScrollViewInsets = NO;
    for (int row = 0; row<4; row++) {
        for (int col=0; col<3; col++) {
            if (row==0) {
                CourseMemoryView *cmv = [[CourseMemoryView alloc] initWithFrame:CGRectMake(col*c, 0, c, c+16)];
                [cmv setDic:self.arr[col]];
                cmv.courseButton.tag = col;
                [cmv.courseButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:cmv];
            }else{
                CourseMemoryView1 *cmv1 = [[CourseMemoryView1 alloc] initWithFrame:CGRectMake(col*c, row*(c+16), c, c+16)];
                [cmv1 setDic:self.arr[row*3+col]];
                cmv1.courseButton.tag = row*3+col;
                [cmv1.courseButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:cmv1];
            }
        }
    }
}
- (void)itemClick:(UIButton *)sender{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil && userInfo == nil) {
        [self returnToLogin];
    }else if (token ==nil&& (userInfo[@"associatedWx"] != nil || userInfo[@"associatedQq"] != nil)) {
        [self returnToBingingPhone];
    }else{
        if ([self.phoneNum isEqualToString:@"13312345678"]) {
            [YHHud showWithMessage:@"课程正在研制中"];
        }else{
            if (sender.tag==0) {
                _grade_type = [NSString stringWithFormat:@"%zd",sender.tag+1];
                [self performSegueWithIdentifier:@"toItemDetail" sender:self];
            }else{
                [YHHud showWithMessage:@"课程正在研制中"];
            }
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toItemDetail"]) {
        GradeVC *gradeVC = segue.destinationViewController;
        gradeVC.grade_type =_grade_type;
    }
}
@end
