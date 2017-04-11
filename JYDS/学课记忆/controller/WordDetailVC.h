//
//  WordDetailVC.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
@protocol WordDetailVCDelegate<NSObject>
- (void)updateWordList;
@end
@interface WordDetailVC : BaseViewController
@property (strong,nonatomic) Word *word;
@property (copy,nonatomic) NSString *classId;
@property (copy,nonatomic) NSString *unitId;
@property (weak,nonatomic) id<WordDetailVCDelegate> delegate;
@end
