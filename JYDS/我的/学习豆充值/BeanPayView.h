//
//  BeanPayView.h
//  JYDS
//
//  Created by liyu on 2017/7/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeanPayViewDelegate<NSObject>
- (void)itemClick:(NSInteger)itemIndex;
@end
@interface BeanPayView : UIView
@property (strong,nonatomic) UILabel *moneyLabel;
@property (strong,nonatomic) UILabel *studyBeanLabel;
@property (weak,nonatomic) id<BeanPayViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag;
@end
