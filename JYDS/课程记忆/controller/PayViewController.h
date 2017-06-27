//
//  PayViewController.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : BaseViewController
@property (copy,nonatomic) NSString *classId;
@property (copy,nonatomic) NSString *memoryId;
@property (copy,nonatomic) NSString *payType;
@property (copy,nonatomic) NSString *inviteCount;
@property (copy,nonatomic) NSString *preferentialPrice;
@property (copy,nonatomic) NSString *payPrice;
@property (assign,nonatomic) SubType subType;
@end
