//
//  ButtomCell.h
//  JYDS
//
//  Created by liyu on 2017/3/24.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ButtomCellDelegate<NSObject>
- (void)telephoneClick;
@end
@interface ButtomCell : UITableViewCell
@property (weak,nonatomic) id<ButtomCellDelegate> delegate;
@end
