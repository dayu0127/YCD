//
//  ResultView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ResultViewDelegate<NSObject>
- (void)backToExerciselView;
- (void)backToLevelView;
@end
@interface ResultView : UIView

@property (strong,nonatomic) NSMutableArray<UIView *> *viewArray;
@property (weak,nonatomic) id<ResultViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray *)arr;

@end
