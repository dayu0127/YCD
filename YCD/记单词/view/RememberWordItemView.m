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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.text = dic[@"sectionName"];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.cornerRadius = 3.0f;
    _titleLabel.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    CGFloat width = [_titleLabel.text boundingRectWithSize:CGSizeMake(1000, 23) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0f] forKey:NSFontAttributeName] context:nil].size.width;
    _titleLabel.frame = CGRectMake(10, 16, width+40, 23);
    [_bgView addSubview:_titleLabel];
    NSArray *itemArray = dic[@"sectionDetail"];
    UIView *lastView = nil;
    for (int i = 0; i < itemArray.count; i++) {
        NSDictionary *itemDic = itemArray[i];
        UIButton *item_btn = [[UIButton alloc] init];
        item_btn.translatesAutoresizingMaskIntoConstraints = NO;
        item_btn.tag = [itemDic[@"id"] integerValue];
        [item_btn dk_setTitleColorPicker:DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],RED) forState:UIControlStateNormal];
        [item_btn setTitle:itemDic[@"classifyName"] forState:UIControlStateNormal];
        item_btn.layer.cornerRadius = 6.0f;
        item_btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        item_btn.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,N_CELL_BG,RED);
        [item_btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:item_btn];
        
        NSMutableArray *layoutArray = [NSMutableArray array];
        [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
        if (i % 2 == 0) {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
            if (lastView == nil) {
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
            }else {
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            }
        }else {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1 constant:20]];
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        }
        if (i == itemArray.count - 1) {
            [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
            if (i % 2 == 0) {
                [layoutArray addObject:[NSLayoutConstraint constraintWithItem:item_btn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-10]];
            }
        }
        
        [NSLayoutConstraint activateConstraints:layoutArray];
        lastView = item_btn;
        
    }
    
}

- (void)itemClick:(UIButton *)sender{
    [_delegate itemClickWithClassifyID:sender.tag title:sender.titleLabel.text];
}


@end
