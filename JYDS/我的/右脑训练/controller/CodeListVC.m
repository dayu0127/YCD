//
//  CodeListVC.m
//  JYDS
//
//  Created by liyu on 2017/1/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "CodeListVC.h"

@interface CodeListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) NSMutableArray *arr;
@property (strong,nonatomic) UICollectionView *collectionView;
@end

@implementation CodeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((WIDTH-20)/3.0, (WIDTH-20)/3.0);
    layout.minimumLineSpacing = 10; //上下的间距 可以设置0看下效果
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)arr{
    if (!_arr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"codeName" ofType:@"plist"];
        _arr = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return _arr;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat c = (WIDTH-20)/3.0;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, c, c-13)];
    NSString *imageName = @"";
    if (indexPath.row!=self.arr.count-1) {
        imageName = [NSString stringWithFormat:@"%01zd",indexPath.row];
    }else{
        imageName = @"00";
    }
    imageView.image = [UIImage imageNamed:imageName];
    [cell.contentView addSubview:imageView];
    //text
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, c-13, c, 13)];
    textLabel.text = self.arr[indexPath.row];
    textLabel.font = [UIFont systemFontOfSize:13.0f];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:textLabel];
    return cell;
}

@end
