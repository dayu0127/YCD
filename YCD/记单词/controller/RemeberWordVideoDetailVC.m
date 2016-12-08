//
//  RemeberWordVideoDetailVC.m
//  YCD
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RemeberWordVideoDetailVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RemeberWordSingleWordDetailVC.h"
@interface RemeberWordVideoDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *buttonAarry;
@property (nonatomic,strong)UIView *underLine;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UITextView *contentText;
@property (nonatomic,strong)NSMutableArray *wordArray;
@property (nonatomic,strong)NSMutableArray *courseArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)NSInteger flagForCollectionView;
@property (nonatomic,strong)NSMutableArray *courseButtonArray;
@end

@implementation RemeberWordVideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _courseButtonArray = [NSMutableArray array];
    //播放器
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    NSURL *sourceMovieURL = [NSURL URLWithString:@"http://m3.rui2.net/uploadfile/output/2015/0226/d56e56eeb7ae97cc.mp4"];
    playerVC.player = [[AVPlayer alloc] initWithURL:sourceMovieURL];
    playerVC.view.frame = CGRectMake(0, 64, WIDTH, HEIGHT*0.3);
    [self addChildViewController:playerVC];
    [self.view addSubview:playerVC.view];
    //标题视图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+0.3*HEIGHT, WIDTH, 39)];
    titleView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    [self.view addSubview:titleView];
    _buttonAarry = [NSMutableArray arrayWithCapacity:3];
    NSArray *titleArray = @[@"本节说明",@"本节单词",@"其他节课"];
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(90*i, 0, 90, 38)];
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [btn dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        btn.tag = i;
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        [_buttonAarry addObject:btn];
    }
    //下划线
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 90, 1)];
    _underLine.backgroundColor = [UIColor orangeColor];
    [titleView addSubview:_underLine];
    //分享
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-65, 0, 35, 39)];
    shareLabel.text = @"分享";
    shareLabel.font = [UIFont systemFontOfSize:15.0f];
    shareLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkTextColor],[UIColor whiteColor],RED);
    [titleView addSubview:shareLabel];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-30, 11.5, 16, 16)];
    [shareButton setImage:[UIImage imageNamed:@"wodezixuan"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shareButton];
    //分割线
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), WIDTH, 1)];
    _line.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor groupTableViewBackgroundColor],[UIColor darkGrayColor],RED);
    [self.view addSubview:_line];
    //本节说明(本节单词,其他课程)
    [self loadCurrentSectionExplain];
}
- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        _wordArray = [NSMutableArray arrayWithObjects:@"about",@"because",@"code",@"discover",@"dispath",@"ever",@"forget",@"give",@"hour",@"italic",@"jump",@"keep", nil];
    }
    return _wordArray;
}
- (NSMutableArray *)courseArray{
    if (!_courseArray) {
        _courseArray = [NSMutableArray arrayWithObjects:@"【人教版】小学四年级上第一节",@"【人教版】小学四年级上第一节",@"【人教版】小学四年级上第一节",@"【人教版】小学四年级上第一节",@"【人教版】小学四年级上第一节",@"【人教版】小学四年级上第一节", nil];
    }
    return _courseArray;
}
#pragma mark 选项卡标题点击
- (void)titleButtonClick:(UIButton *)sender{
    for (UIButton *item in _buttonAarry) {
        item.selected = NO;
    }
    sender.selected = YES;
    _underLine.frame = CGRectMake(90*sender.tag, 38, 90, 1);
    if (sender.tag == 0) { //点击加载本节说明
        [self loadCurrentSectionExplain];
    }else if(sender.tag == 1){ //点击加载本节单词
        _flagForCollectionView = 0;
        [self loadOtherCourse];
    }else{
        _flagForCollectionView = 1;
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
    _contentText.editable = NO;
    _contentText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    NSString *textString = @"四年级上学期第一节课";
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textString.length)];
    _contentText.attributedText = content;
    _contentText.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _contentText.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    _contentText.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:_contentText];
}
#pragma mark 加载其他课程
- (void)loadOtherCourse{
    if (_collectionView!=nil) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
        [_courseButtonArray removeAllObjects];
        _courseButtonArray = nil;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    if (_flagForCollectionView == 0) {
        layout.itemSize = CGSizeMake((WIDTH-60)*0.5, 44);
        layout.sectionInset = UIEdgeInsetsMake(10,15,10,15);
    }else{
        layout.itemSize = CGSizeMake(WIDTH-40, 44);
        layout.sectionInset = UIEdgeInsetsMake(10,20,10,20);
        _courseButtonArray = [NSMutableArray array];
    }
    layout.minimumLineSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), WIDTH, HEIGHT-CGRectGetMaxY(_line.frame)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _flagForCollectionView == 0 ? self.wordArray.count : self.courseArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CGFloat width = _flagForCollectionView == 0 ? (WIDTH-60)*0.5 : (WIDTH-40);
    UIButton *courseItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    NSString *title = _flagForCollectionView == 0 ? self.wordArray[indexPath.row] : self.courseArray[indexPath.row];
    [courseItemButton setTitle:title forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [courseItemButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    courseItemButton.tag = indexPath.row;
    courseItemButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    courseItemButton.layer.masksToBounds = YES;
    courseItemButton.layer.cornerRadius = 8.0f;
    if (_flagForCollectionView == 0) {
        [courseItemButton addTarget:self action:@selector(wordItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [courseItemButton addTarget:self action:@selector(courseItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.contentView addSubview:courseItemButton];
    if (_flagForCollectionView == 1) {
        [_courseButtonArray addObject:courseItemButton];
    }
    return cell;
}
- (void)wordItemButtonClick:(UIButton *)sender{
    RemeberWordSingleWordDetailVC *wordDetailVC = [[RemeberWordSingleWordDetailVC alloc] init];
    [self.navigationController pushViewController:wordDetailVC animated:YES];
}
- (void)courseItemButtonClick:(UIButton *)sender{
    for (UIButton *btn in _courseButtonArray) {
        btn.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
    }
    UIButton *currentBtn = [_courseButtonArray objectAtIndex:sender.tag];
    currentBtn.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}

@end
