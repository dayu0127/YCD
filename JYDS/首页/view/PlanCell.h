//
//  PlanCell.h
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@end
