//
//  UserInfo.h
//  JYDS
//
//  Created by liyu on 2017/1/4.
//  Copyright © 2017年 dayu. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong,nonatomic) NSString *userID;  //用户ID
@property (strong,nonatomic) NSString *userName;    //用户名
@property (strong,nonatomic) NSString *nickName;    //昵称
@property (strong,nonatomic) NSString *headImageUrl;    //头像
@property (strong,nonatomic) NSString *costStudyBean;   //已消耗学习豆
@property (strong,nonatomic) NSString *studyCode;   //互学码
@property (strong,nonatomic) NSString *loginStatus; //登录状态
@property (strong,nonatomic) NSString *studyBean;   //剩余学习豆

@end
