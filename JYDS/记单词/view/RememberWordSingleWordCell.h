//
//  RememberWordSingleWordCell.h
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RememberWordSingleWordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *wordPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordPriceWidth;

- (void)addModelWidthDic:(NSDictionary *)dic;

@end
