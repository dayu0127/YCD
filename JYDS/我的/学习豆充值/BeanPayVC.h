//
//  BeanPayVC.h
//  JYDS
//
//  Created by liyu on 2017/7/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeanPayVCDelegate<NSObject>
- (void)updateBean:(NSString *)bean;
- (void)showCancelOrderAlert;
@end
@interface BeanPayVC : BaseViewController
@property (weak,nonatomic) id<BeanPayVCDelegate> delegate;
@end
