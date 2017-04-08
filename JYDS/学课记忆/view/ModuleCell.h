//
//  ModuleCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moduleNameLabel;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
