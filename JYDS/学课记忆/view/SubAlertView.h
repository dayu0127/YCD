//
//  SubAlertView.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SubAlertViewDelegate<NSObject>
- (void)closeClick;
- (void)continueSubClick;
- (void)invitateFriendClick;
@end
@interface SubAlertView : UIView
@property (copy,nonatomic) NSString *grade;
@property (copy,nonatomic) NSString *price;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *invitateFriendBtn;
@property (weak,nonatomic) id<SubAlertViewDelegate> delegate;
- (instancetype)initWithNib;
@end
