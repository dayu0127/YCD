//
//  MemoryCourseVC.h
//  JYDS
//
//  Created by dayu on 2016/11/29.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MemoryCourseVCDelegate<NSObject>
- (void)reloadMemoryList;
@end
@class Mnemonics;
@interface MemoryCourseVC : BaseViewController

@property (nonatomic,strong) Mnemonics *memory;
@property (nonatomic,strong) NSArray *memoryArray;
@property (weak,nonatomic) id<MemoryCourseVCDelegate> delegate;

@end
