//
//  UIButton+ImageTitleSpacing.h
//  JYDS
//
//  Created by liyu on 2017/3/28.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YHButtonEdgeInsetsStyle) {
    YHButtonEdgeInsetsStyleTop, // image在上，label在下
    YHButtonEdgeInsetsStyleLeft, // image在左，label在右
    YHButtonEdgeInsetsStyleBottom, // image在下，label在上
    YHButtonEdgeInsetsStyleRight // image在右，label在左
};
@interface UIButton (ImageTitleSpacing)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(YHButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;
@end
