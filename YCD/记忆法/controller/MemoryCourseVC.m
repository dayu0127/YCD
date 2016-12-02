//
//  MemoryCourseVC.m
//  YCD
//
//  Created by dayu on 2016/11/29.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import "MemoryCourseVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MemoryCourseVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIButton *titleButton1;
@property (nonatomic,strong)UIButton *titleButton2;
@property (nonatomic,strong)UIView *underLine;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)NSMutableArray *courceArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@end

@implementation MemoryCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //播放器
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    NSURL *sourceMovieURL = [NSURL URLWithString:@"http://m3.rui2.net/uploadfile/output/2015/0226/d56e56eeb7ae97cc.mp4"];
    playerVC.player = [[AVPlayer alloc] initWithURL:sourceMovieURL];
    playerVC.view.frame = CGRectMake(0, 64, WIDTH, HEIGHT*0.3);
    [self addChildViewController:playerVC];
    [self.view addSubview:playerVC.view];
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+0.3*HEIGHT, WIDTH, 39)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    //本节说明
    _titleButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 38)];
    [_titleButton1 setTitle:@"本节说明" forState:UIControlStateNormal];
    [_titleButton1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _titleButton1.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton1.tag = 0;
    [_titleButton1 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton1];
    //其他课程
    _titleButton2 = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 90, 38)];
    [_titleButton2 setTitle:@"其他课程" forState:UIControlStateNormal];
    [_titleButton2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _titleButton2.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleButton2.tag = 1;
    [_titleButton2 addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_titleButton2];
    //下划线
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 90, 1)];
    _underLine.backgroundColor = [UIColor orangeColor];
    [titleView addSubview:_underLine];
    //分享
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-65, 0, 35, 39)];
    shareLabel.text = @"分享";
    shareLabel.font = [UIFont systemFontOfSize:15.0f];
    shareLabel.textColor = [UIColor lightGrayColor];
    [titleView addSubview:shareLabel];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-30, 11.5, 16, 16)];
    [shareButton setImage:[UIImage imageNamed:@"wodezixuan"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shareButton];
    //分割线
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), WIDTH, 1)];
    _line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_line];
    //本节说明(其他课程)
    [self loadCurrentSectionExplain];
}
- (NSMutableArray *)courceArray{
    if (!_courceArray) {
        _courceArray = [NSMutableArray arrayWithObjects:@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程",@"记忆法课程", nil];
    }
    return _courceArray;
}
- (void)titleButtonClick:(UIButton *)sender{
    if (sender.tag == 0) {
        //点击本节说明
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_titleButton2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _underLine.frame = CGRectMake(0, 38, 90, 1);
        [self loadCurrentSectionExplain];
    }else{
        //点击其他课程
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_titleButton1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _underLine.frame = CGRectMake(90, 38, 90, 1);
        [self loadOtherCourse];
    }
}
#pragma mark 分享
- (void)shareButtonClick{
    NSLog(@"分享");
}
#pragma mark 加载本节说明
- (void)loadCurrentSectionExplain{
    if (_contentText!=nil) {
        [_contentText removeFromSuperview];
        _contentText = nil;
    }
    _contentText = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame))];
    _contentText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *textString = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它。  --阿尔伯特·爱因斯坦";
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textString.length)];
    _contentText.attributedText = content;
    _contentText.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:_contentText];
}
#pragma mark 加载其他课程
- (void)loadOtherCourse{
    if (_collectionView!=nil) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((WIDTH-60)*0.5, 44);
    layout.minimumLineSpacing = 15; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(15,15,15,15);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.courceArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIButton *courseItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (WIDTH-60)*0.5, 44)];
    [courseItemButton setTitle:self.courceArray[indexPath.row] forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [courseItemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    courseItemButton.tag = indexPath.row;
    courseItemButton.backgroundColor = [UIColor whiteColor];
    courseItemButton.layer.masksToBounds = YES;
    courseItemButton.layer.cornerRadius = 8.0f;
    [courseItemButton addTarget:self action:@selector(courseItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:courseItemButton];
    return cell;
}
- (void)courseItemButtonClick:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}
@end
