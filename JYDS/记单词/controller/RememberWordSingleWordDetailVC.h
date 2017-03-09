//
//  RememberWordSingleWordDetailVC.h
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Words;

@interface RememberWordSingleWordDetailVC : BaseNavViewController

@property (nonatomic,strong) Words *word;
@property (nonatomic,strong) NSArray *wordIDArray;
@property (nonatomic,assign) NSInteger wordIndex;
@property (nonatomic,assign) BOOL isSub;

@end
