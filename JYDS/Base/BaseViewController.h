//
//  BaseViewController.h
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface BaseViewController : UIViewController
@property (copy,nonatomic) NSString *phoneNum;
@property (copy,nonatomic) NSString *token;
@property (copy,nonatomic) NSString *associatedQq;
@property (copy,nonatomic) NSString *associatedWx;
- (void)returnToLogin;
- (void)returnToBingingPhone;
@end
