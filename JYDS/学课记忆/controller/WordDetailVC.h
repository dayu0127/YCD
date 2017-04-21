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
@optional
- (void)updateWordList;
- (void)updateMyCollectList;
@end
@interface WordDetailVC : BaseViewController
@property (strong,nonatomic) Word *word;
@property (weak,nonatomic) id<WordDetailVCDelegate> delegate;
@property (assign,nonatomic) BOOL showCollectButton;
@property (assign,nonatomic) BOOL isMyCollect;
@property (assign,nonatomic) NSInteger indexOfWord;
@end
