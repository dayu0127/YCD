//
//  BingingPhoneVC.h
//  JYDS
//
//  Created by liyu on 2017/4/1.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BingingPhoneVCDelegate<NSObject>
- (void)updatePhoneBingingState:(NSString *)phone;
@end
@interface BingingPhoneVC : BaseViewController
@property (weak,nonatomic) id<BingingPhoneVCDelegate> delegate;
@end
