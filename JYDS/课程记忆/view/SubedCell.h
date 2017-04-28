//
//  SubedCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
@interface SubedCell : BaseCell

@property (strong, nonatomic) UILabel *wordLabel;
//@property (strong, nonatomic) UIButton *collectButton;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
