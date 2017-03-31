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
    _arr = @[@{@"img":@"mysub_word",@"title":@"已订阅单词数"},
              @{@"img":@"mysub_course",@"title":@"已订阅课程"}];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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

@end
