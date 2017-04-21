//
//  LevelView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LevelViewDelegate<NSObject>
- (void)startExerciseClick:(NSInteger)level;
@end
@interface LevelView : UIView
@property (weak,nonatomic) id<LevelViewDelegate> delegate;
@property (strong,nonatomic) NSMutableArray<UIButton *> *buttonArray;
@property (assign,nonatomic) NSInteger currentLevel;
@end
