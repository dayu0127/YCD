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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImg;
@property (weak, nonatomic) IBOutlet UIImageView *memoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *subCountLabel;
- (void)addModelWithDic:(NSDictionary *)dic;

@end
