//
//  NotSubCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotSubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
