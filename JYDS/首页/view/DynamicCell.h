//
//  DynamicCell.h
//  JYDS
//
//  Created by 大雨 on 2017/3/28.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DynamicCellDelegate<NSObject>
- (void)dynamicClick:(NSInteger)index;
@end
@interface DynamicCell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) NSInteger imageCount;
@property (strong,nonatomic) UIButton *leftButton;
@property (strong,nonatomic) UIButton *rightButton;
@property (weak,nonatomic) id<DynamicCellDelegate> delegete;
- (void)configScrollView:(NSArray *)arr;
@end
