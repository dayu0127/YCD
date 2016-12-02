//
//  RememberWordItemView.m
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordItemView.h"

@implementation RememberWordItemView

- (instancetype)initWithNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setDic:(NSDictionary *)dic {
    
    for (UIView *subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    _titleLabel.text = dic[@"name"];
    NSArray *array = dic[@"detail"];
    UIView *lastView = nil;
    for (int i = 0; i < array.count; i++) {
        
        NSString *str = array[i];
        UIButton *item_btn = [[UIButton alloc] init];
        item_btn.translatesAutoresizingMaskIntoConstraints = NO;
        item_btn.tag = i;
        item_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [item_btn setTitle:str forState:UIControlStateNormal];
        item_btn.titleLabel.font = [UIFont systemFontOfSize:13.5f];
        item_btn.backgroundColor = [UIColor orangeColor];
        [item_btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:item_btn];
        
        NSMutableArray *layoutArray = [NSMutableArray array];
        [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];
        if (i % 2 == 0) {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
            if (lastView == nil) {
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
            }else {
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            }
            
        }else {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        }
        if (i == array.count - 1) {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
            if (i % 2 == 0) {
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-2.5]];
            }
        }
        
        [NSLayoutConstraint activateConstraints:layoutArray];
        lastView = item_btn;
        
    }
    
}

- (void)itemClick:(UIButton *)sender{
    [_delegate itemClickTitleIndex:self.tag itemIndex:sender.tag];
}


@end
