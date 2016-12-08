//
//  CustomAlertView.h
//  YCD
//
//  Created by liyu on 2016/12/8.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomAlertViewDelegate<NSObject>
- (void)buttonClickIndex:(NSInteger)buttonIndex;
@end
@interface CustomAlertView : UIView
@property (weak,nonatomic) id<CustomAlertViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message;
@end
