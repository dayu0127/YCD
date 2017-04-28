//
//  ResultView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ExerciseDelegate.h"
@interface ResultView : UIView<WKNavigationDelegate>
@property (weak,nonatomic) id<ExerciseDelegate> delegate;
@property (strong,nonatomic) WKWebView *wkWebView;
@property (strong,nonatomic) UIButton *continueButton;
@property (strong,nonatomic) UIButton *backButton;
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray *)arr;
@end
