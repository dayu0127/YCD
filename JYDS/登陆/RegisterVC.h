//
//  RegisterVC.h
//  JYDS
//
//  Created by dayu on 2016/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol RegisterVCDelegate<NSObject>
- (void)autoFillUserName:(NSString *)userName;
@end
@interface RegisterVC : BaseViewController
@property (strong,nonatomic) id<RegisterVCDelegate> delegate;
@end
