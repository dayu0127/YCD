//
//  StartView.h
//  JYDS
//
//  Created by liyu on 2017/4/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StartViewDelegate<NSObject>
- (void)codeListClick;
- (void)useMethodClick;
- (void)enterExerciseClick;
@end
@interface StartView : UIView
@property (weak,nonatomic) id<StartViewDelegate> delegate;
@end
