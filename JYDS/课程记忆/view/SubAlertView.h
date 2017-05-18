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
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label_0;
@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak,nonatomic) id<SubAlertViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_0_height;
- (instancetype)initWithNib;
- (void)setTitle:(NSString *)title discountPrice:(NSString *)discountPrice fullPrice:(NSString *)fullPrice subType:(SubType)subType;
@end
