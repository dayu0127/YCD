//
//  CourseMemoryView.h
//  JYDS
//
//  Created by liyu on 2017/4/4.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CourseMemoryView : UIView
@property (strong, nonatomic) UIButton *courseButton;
@property (strong, nonatomic) UILabel *courseLabel;
- (void)setDic:(NSDictionary *)dic;
@end
