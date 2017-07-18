//
//  PayDetailCell.h
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PayDetailCellDelegate<NSObject>
- (void)surePayClick;
- (void)beanPayClick;
@end
@interface PayDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inviteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferentialPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width2;

@property (weak, nonatomic) IBOutlet UILabel *myBeanLabel;
@property (weak,nonatomic) id<PayDetailCellDelegate> delegate;
@end
