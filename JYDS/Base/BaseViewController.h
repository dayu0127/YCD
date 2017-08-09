//
//  BaseViewController.h
//  JYDS
//
//  Created by 李禹 on 2016/12/2.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
@interface BaseViewController : UIViewController
@property (copy,nonatomic) NSString *phoneNum;
@property (copy,nonatomic) NSString *token;
@property (copy,nonatomic) NSString *associatedQq;
@property (copy,nonatomic) NSString *associatedWx;
@property (copy,nonatomic) NSString *associatedWb;
@property (copy,nonatomic) UILabel *label;
- (void)returnToLogin;
- (void)returnToHome;
- (void)returnToBingingPhone;
- (void)loadNoInviteView:(NSString *)str;
- (void)loginInterceptCompletion:(void(^)(void))completion;
- (void)loginSuccess:(NSString *)jsonString;
- (void)otherLogin:(UMSocialPlatformType)platformType;
- (void)getBannerInfo;
@end
