//
//  PayDetailCell.h
//  JYDS
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface PayDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *payDate;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;

@end
