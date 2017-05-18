//
//  MemoryMoreCell.h
//  JYDS
//
//  Created by liyu on 2017/4/11.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MemoryMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *subCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memoryImageView;

- (void)addModelWithDic:(NSDictionary *)dic;

@end
