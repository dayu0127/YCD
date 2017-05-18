//
//  MemorySeriseCell.h
//  JYDS
//
//  Created by liyu on 2017/5/4.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemorySeriseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *seriseImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImg;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@end
