//
//  TopMenuView.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopMenuViewDelegate<NSObject>
- (void)menuClick:(UIButton *)sender;
@end
@interface TopMenuView : UIView
@property (weak,nonatomic) id<TopMenuViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag;
@end
