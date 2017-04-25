//
//  MemoryHeaderView.h
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MemoryHeaderViewDelegate<NSObject>
- (void)pushMoreMemoryList;
@end
@interface MemoryHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) id<MemoryHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *arrows;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
+ (instancetype)loadView;

@end
