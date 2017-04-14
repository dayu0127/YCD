//
//  MySubVC.m
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MySubVC.h"
#import "MySubCell.h"
@interface MySubVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *arr;
@end

@implementation MySubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView registerNib:[UINib nibWithNibName:@"MySubCell" bundle:nil] forCellReuseIdentifier:@"MySubCell"];
    _arr = @[@{@"img":@"mysub_course",@"title":@"已订阅记忆法课程"},
                @{@"img":@"mysub_word",@"title":@"已订阅学课记忆"}];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\
    MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MySubCell" forIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:_arr[indexPath.row][@"img"]];
    cell.tile.text = _arr[indexPath.row][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) { //记忆法
        [self performSegueWithIdentifier:@"toMySubMemoryList" sender:self];
    }else{  //k12
        [self performSegueWithIdentifier:@"toMySubCourseList" sender:self];
    }
}
@end
