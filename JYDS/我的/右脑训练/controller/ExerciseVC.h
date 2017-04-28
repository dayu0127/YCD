//
//  ExerciseVC.h
//  JYDS
//
//  Created by liyu on 2017/4/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExerciseVCDelegate<NSObject>
- (void)setLevel:(NSInteger)level;
@end
@interface ExerciseVC : BaseViewController
@property (assign,nonatomic) NSInteger level;
@property (assign,nonatomic) NSInteger exerciseCount;
@property (assign,nonatomic) NSInteger index;
@property (weak,nonatomic) id<ExerciseVCDelegate> delegate;
@property (strong,nonatomic) NSMutableArray<NSString *> *numArray;
@end
