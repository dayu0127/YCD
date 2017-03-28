//
//  MemoryHeaderView.h
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoryHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
+ (instancetype)loadView;
@end
