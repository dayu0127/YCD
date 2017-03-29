//
//  LoggedInHeaderView.h
//  JYDS
//
//  Created by liyu on 2017/3/25.
//  Copyright © 2017年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol LoggedInHeaderViewDelegate<NSObject>
- (void)pushToUserInfo;
@end
@interface LoggedInHeaderView : UIView
@property (strong,nonatomic)UIButton *headImageButton;
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)UILabel *phoneLabel;
@property (weak,nonatomic) id<LoggedInHeaderViewDelegate> delegate;
@end
