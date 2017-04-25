//
//  SetCell0.h
//  JYDS
//
//  Created by 大雨 on 2017/3/29.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell0 : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel0;
@property (strong,nonatomic) UILabel *bingingLabel;
@property (strong,nonatomic) UIImageView *arrows;
@property (strong,nonatomic) UILabel *titleLabel1;
- (void)setCellWithString:(NSString *)str;
@end
