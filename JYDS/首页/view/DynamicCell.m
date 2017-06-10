//
//  DynamicCell.m
//  JYDS
//
//  Created by 大雨 on 2017/3/28.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "DynamicCell.h"
#import <UIImageView+WebCache.h>

@implementation DynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)configScrollView:(NSArray *)arr{
    NSMutableArray *netImages = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [netImages addObject:dic[@"url"]];
    }
    _imageCount = netImages.count;
    CGFloat w = WIDTH-20;
    CGFloat h = 177/355.0*(WIDTH-20);
    _scrollView.contentSize = CGSizeMake(w*_imageCount, h);
    _scrollView.delegate = self;
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:[UIImage imageNamed:@"home_arrow"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView insertSubview:_leftButton atIndex:1];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    _leftButton.alpha = 0;
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setImage:[UIImage imageNamed:@"home_arrows"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView insertSubview:_rightButton atIndex:1];;
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    if (_imageCount == 1) {
        _leftButton.alpha = 0;
        _rightButton.alpha = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:netImages[0]] placeholderImage:[UIImage imageNamed:@"banner"]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:tap];
        UIView *singleTapView = [tap view];
        singleTapView.tag = 0;
        [_scrollView insertSubview:imageView atIndex:0];
    }else if(_imageCount > 1){
        for (int i = 0; i<_imageCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*i, 0, w, h)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:netImages[i]] placeholderImage:[UIImage imageNamed:@"banner"]];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [imageView addGestureRecognizer:tap];
            UIView *singleTapView = [tap view];
            singleTapView.tag = i;
            [_scrollView insertSubview:imageView atIndex:0];
        }
    }
}
- (void)imageClick:(UITapGestureRecognizer *)sender{
    [_delegete dynamicClick:[sender view].tag];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_imageCount>2) {
        if (scrollView.contentOffset.x == 0) {
            _leftButton.alpha = 0;
        }else if (scrollView.contentOffset.x/(WIDTH-20)==_imageCount-1){
            _rightButton.alpha = 0;
        }else{
            _leftButton.alpha = 1;
            _rightButton.alpha = 1;
        }
    }else{
        if (scrollView.contentOffset.x == 0) {
            _leftButton.alpha = 0;
            _rightButton.alpha = 1;
        }else{
            _leftButton.alpha = 1;
            _rightButton.alpha = 0;
        }
    }
    if (scrollView.contentOffset.x<0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    if (scrollView.contentOffset.x>(WIDTH-20)*(_imageCount-1)) {
        [scrollView setContentOffset:CGPointMake((WIDTH-20)*(_imageCount-1), 0)];
    }
}
- (void)leftButtonClick:(UIButton *)sender{
    CGPoint currentPoint = _scrollView.contentOffset;
    currentPoint.x-=(WIDTH-20);
    [_scrollView setContentOffset:currentPoint animated:YES];
    if (currentPoint.x == 0) {
        sender.alpha = 0;
    }else{
        sender.alpha = 1;
        _rightButton.alpha = 1;
    }
}
- (void)rightButtonClick:(UIButton *)sender{
    CGPoint currentPoint = _scrollView.contentOffset;
    currentPoint.x+=(WIDTH-20);
    [_scrollView setContentOffset:currentPoint animated:YES];
    if (currentPoint.x/(WIDTH-20) == _imageCount-1) {
        sender.alpha = 0;
    }else{
        sender.alpha = 1;
        _leftButton.alpha = 1;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
