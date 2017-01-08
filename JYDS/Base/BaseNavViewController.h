//
//  BaseNavViewController.h
//  JYDS
//
//  Created by liyu on 2016/12/31.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface BaseNavViewController : UIViewController

@property (strong, nonatomic) UIView *navBar;
@property (strong,nonatomic) NSString *navTitle;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *leftBarButton;
@property (strong, nonatomic) UIButton *rightBarButton;

- (void)initNaBar:(NSString *)title;

@end
