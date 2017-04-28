//
//  UserInfo.h
//  JYDS
//
//  Created by liyu on 2017/1/4.
//  Copyright © 2017年 dayu. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface UserInfo : NSObject

@property (strong,nonatomic) NSString *phoneNum;  //用户手机号
@property (strong,nonatomic) NSString *associatedQq;  //QQ绑定的uid (唯一标识)
@property (strong,nonatomic) NSString *associatedWx;  //微信绑定的uid (唯一标识)
@property (strong,nonatomic) NSString *freeCount;   //免费单词订阅次数
@property (strong,nonatomic) NSString *headImg;  //头像
@property (strong,nonatomic) NSString *inviteNum;  //邀请人数
@property (strong,nonatomic) NSString *invitePhoneNum;  //邀请人手机号
@property (strong,nonatomic) NSString *genter;  //性别
@property (strong,nonatomic) NSString *nickName;  //昵称
@property (strong,nonatomic) NSString *points;  //积分

@end
