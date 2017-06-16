//
//  PlanCell.h
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlanCellDelegate<NSObject>
- (void)pushToMySub;
- (void)pushToMemoryMore;
- (void)pushToInvitation;
- (void)pushToCourseMemory;
@end
@interface PlanCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@property (weak,nonatomic) id<PlanCellDelegate> delegate;
@end
