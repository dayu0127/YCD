//
//  WordDetailCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *splitOrAssociateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
