//
//  ModuleCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordNumLabel;

- (void)addModelWithDic:(NSDictionary *)dic;
@end
