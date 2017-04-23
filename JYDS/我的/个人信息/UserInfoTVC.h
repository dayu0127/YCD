//
//  UserInfoTVC.h
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserInfoTVCDelegate<NSObject>
- (void)updateHeadImage:(UIImage *)img;
- (void)updateNickName:(NSString *)str;
@end
@interface UserInfoTVC : UITableViewController
@property (weak,nonatomic) id<UserInfoTVCDelegate> delegate;
@property (strong,nonatomic) UIImage *headImage;
@end
