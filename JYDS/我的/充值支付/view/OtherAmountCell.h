//
//  OtherAmountCell.h
//  JYDS
//
//  Created by liyu on 2017/2/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherAmountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momeyLabelWidth;
@end
