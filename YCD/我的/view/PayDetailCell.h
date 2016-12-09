//
//  PayDetailCell.h
//  YCD
//
//  Created by dayu on 2016/12/1.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paySuccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
