//
//  UserInfoTVC.h
//  JYDS
//
//  Created by liyu on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserInfoTVCDelegate<NSObject>
- (void)updateHeadImageAndNickName:(UIImage *)img nickName:(NSString *)str;
@end
@interface UserInfoTVC : UITableViewController

@end
