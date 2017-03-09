//
//  WordSearchCell.h
//  JYDS
//
//  Created by liyu on 2017/3/9.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *subStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subStatusLabelWidth;

- (void)addModelWithDic:(NSDictionary *)dic;
@end
