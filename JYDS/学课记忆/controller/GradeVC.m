//
//  GradeVC.m
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "GradeVC.h"
#import "TopMenuView.h"
#import "GradeCell.h"
@interface GradeVC ()<TopMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topMenuBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation GradeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat c = (WIDTH-2)/3.0;
    NSArray *arr = @[@"年级",@"科目",@"筛选"];
    for (int i = 0; i< 3; i++) {
        TopMenuView *topV = [[TopMenuView alloc] initWithFrame:CGRectMake(i*(c+1), 0, c, 44) title:arr[i] tag:i];
        topV.delegate = self;
        [_topMenuBgView addSubview:topV];
        if (i<2) {
            UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(c*(i+1), 18, 1, 13)];
            v_line.backgroundColor = GRAYCOLOR;
            [_topMenuBgView addSubview:v_line];
        }
    }
    [_tableView registerNib:[UINib nibWithNibName:@"GradeCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)menuClick:(NSInteger)index{
    NSLog(@"%zd",index);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toModuleList" sender:self];
}
@end
