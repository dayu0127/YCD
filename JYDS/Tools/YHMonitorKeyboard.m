//
//  YHMonitorKeyboard.m
//  JYDS
//
//  Created by liyu on 2017/4/12.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "YHMonitorKeyboard.h"
static YHBlock showBlock;
static YHBlock dismissBlock;
@implementation YHMonitorKeyboard
+(void)YHAddMonitorWithShowBack:(YHBlock)showBackBlock andDismissBlock:(YHBlock)dismissBackBlock{
    showBlock = showBackBlock;
    dismissBlock = dismissBackBlock;
    
    //注册监控键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    //注册监控键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:)name:UIKeyboardWillHideNotification object:nil];
}

+(void)keyBoardWillShow:(NSNotification*) notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //获取键盘弹出的时间
    CGFloat interval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect keyboardEndFrame = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardEndFrame.size.height;
    
    [UIView animateWithDuration:interval animations:^{
        if (showBlock) {
            showBlock(keyboardHeight);
        }
    }];
}

+(void)keyBoardWillHidden:(NSNotification*) notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat interval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    CGRect keyboardEndFrame = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardEndFrame.size.height;
    
    [UIView animateWithDuration:interval animations:^{
        if (dismissBlock) {
            dismissBlock(keyboardHeight);
        }
    }];
}
@end
