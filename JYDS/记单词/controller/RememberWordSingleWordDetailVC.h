//
//  RememberWordSingleWordDetailVC.h
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Words;
@protocol RememberWordSingleWordDetailVCDelegate<NSObject>
- (void)reloadWordList;
@end
@interface RememberWordSingleWordDetailVC : UIViewController

@property (nonatomic,strong) Words *word;
@property (nonatomic,strong) NSArray *wordArray;
@property (weak,nonatomic) id<RememberWordSingleWordDetailVCDelegate> delegate;

@end
