//
//  MemoryCell.h
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *memoryTitle;
@property (weak, nonatomic) IBOutlet UIImageView *memoryImage;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
