//
//  ExerciseView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseView : UIView

@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UILabel *preNumLabel;
@property (strong,nonatomic) UILabel *currentNumLabel;
@property (strong,nonatomic) UILabel *nextNumLabel;
@property (strong,nonatomic) NSMutableArray<NSString *> *numArray;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) NSTimer *timer1;
@property (assign,nonatomic) NSInteger totalTime;
@property (assign,nonatomic) NSInteger time;
@property (assign,nonatomic) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame ExerciseNum:(NSInteger)num level:(NSInteger)level;
@end
