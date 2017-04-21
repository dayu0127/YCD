//
//  ResultView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWKWebView.h"
#import "ExerciseDelegate.h"
@interface ResultView : UIView
@property (weak,nonatomic) id<ExerciseDelegate> delegate;
@property (strong,nonatomic) BaseWKWebView *wkWebView;
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray *)arr;
@end
